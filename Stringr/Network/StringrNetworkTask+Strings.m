//
//  StringrNetworkTask+Strings.m
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Strings.h"
#import "StringrNetworkTask+Profile.h"
#import "StringrNetworkTask+User.h"
#import "StringrExploreCategory.h"
#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Activity.h"

#import "StringrString.h"

@interface StringrNetworkTask ()

@property (nonatomic) BOOL isCountQuery;

@end

@implementation StringrNetworkTask (Strings)

#pragma mark - General

+ (PFQuery *)defaultStringQuery
{
    PFQuery *stringQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringQuery includeKey:kStringrStringUserKey];
    
    return stringQuery;
}


- (void)stringsForDataType:(StringrNetworkStringTaskType)dataType completion:(StringrStringsBlock)completion
{
    [self stringsForDataType:dataType user:[PFUser currentUser] completion:completion];
}


- (void)stringsForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrStringsBlock)completion
{
    if (completion) {
        switch (dataType) {
            case StringrUserStringsNetworkTask:
                [StringrNetworkTask stringsForUser:user completion:completion];
                break;
            case StringrFollowingNetworkTask:
                [self homeFeedForUser:user completion:completion];
                break;
            case StringrLikedStringsNetworkTask:
                [StringrNetworkTask likedStringsForUser:user completion:completion];
            default:
                break;
        }
    }
}


#pragma mark - Count

- (void)stringCountForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrCountBlock)completion
{
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *stringsFromFollowedUsersQuery = [self.class defaultStringQuery];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    [stringsFromFollowedUsersQuery includeKey:@"stringStatistics"];
    [stringsFromFollowedUsersQuery setLimit:600];
    [stringsFromFollowedUsersQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (completion) {
            completion(number, error);
        }
    }];
}


#pragma mark - Explore Strings

//+ (void)stringsForCategory:(StringrExploreCategory *)category completion:(StringrStringsBlock)completion
//{
//    if ([category.name isEqualToString:@"Popular"]) {
//        [self popularStrings:completion];
//    }
//    else if ([category.name isEqualToString:@"Discover"]) {
//        [self discoverStrings:completion];
//    }
//    else if ([category.name isEqualToString:@"Near You"]) {
//        [self nearYouStrings:completion];
//    }
//    else {
//        PFQuery *exploreCategoryQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
//        [exploreCategoryQuery whereKey:@"category" equalTo:[category.name lowercaseString]];
//        
//        [exploreCategoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (completion) {
//                completion([StringrString stringsFromArray:objects], error);
//            }
//        }];
//    }
//}


- (void)stringsForCategory:(StringrExploreCategory *)category completion:(StringrStringsBlock)completion
{
    if ([category.name isEqualToString:@"Popular"]) {
        [self.class popularStrings:completion];
    }
    else if ([category.name isEqualToString:@"Discover"]) {
        [self.class discoverStrings:completion];
    }
    else if ([category.name isEqualToString:@"Near You"]) {
        [self.class nearYouStrings:completion];
    }
    else {
        PFQuery *exploreCategoryQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [exploreCategoryQuery whereKey:@"category" equalTo:[category.name lowercaseString]];
        
        [exploreCategoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (completion) {
                completion([StringrString stringsFromArray:objects], error);
            }
        }];
    }
}


+ (void)popularStrings:(StringrStringsBlock)completion
{
    PFQuery *popularQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
    [popularQuery whereKeyExists:kStringrStatisticsStringKey];
    [popularQuery includeKey:kStringrStatisticsStringKey];
    [popularQuery orderByDescending:kStringrStatisticsCommentCountKey];
    [popularQuery addDescendingOrder:kStringrStatisticsLikeCountKey];

    [popularQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *stringsArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
        for (PFObject *statisticObject in objects) {
            PFObject *string = [statisticObject objectForKey:kStringrStatisticsStringKey];
            [string[kStringrStringUserKey] fetchIfNeededInBackground];
            [stringsArray addObject:string];
        }
        
        if (completion) {
            completion([StringrString stringsFromArray:objects], error);
        }
    }];
}


+ (void)discoverStrings:(StringrStringsBlock)completion
{
    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [discoverQuery includeKey:kStringrStringUserKey];
    [discoverQuery orderByDescending:@"updatedAt"];
    
    [discoverQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([StringrString stringsFromArray:objects], error);
        }
    }];
}


+ (void)nearYouStrings:(StringrStringsBlock)completion
{
    PFQuery *nearYouQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    if ([[PFUser currentUser] objectForKey:kStringrUserLocationKey]) {
        [nearYouQuery whereKey:kStringrStringLocationKey nearGeoPoint:[[PFUser currentUser] objectForKey:kStringrUserLocationKey] withinMiles:100.0];
    }
    else {
        [nearYouQuery whereKey:kStringrStringTitleKey equalTo:@"!@#%@#$^%^&*"];
    }
    
    [nearYouQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [nearYouQuery includeKey:kStringrStringUserKey];
    [nearYouQuery orderByDescending:@"createdAt"];
    
    [nearYouQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([StringrString stringsFromArray:objects], error);
        }
    }];
}


#pragma mark - Dashboard

- (void)homeFeedForUser:(PFUser *)user completion:(StringrStringsBlock)completion
{
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    
    PFQuery *stringsFromFollowedUsersQuery = [self.class defaultStringQuery];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    [stringsFromFollowedUsersQuery includeKey:@"stringStatistics"];
    
    if (self.resultsAreAscending) {
        [stringsFromFollowedUsersQuery orderByAscending:@"updatedAt"];
    }
    else {
        [stringsFromFollowedUsersQuery orderByDescending:@"updatedAt"];
    }
    
    if (self.limit > 0) {
        [stringsFromFollowedUsersQuery setLimit:self.limit];
        [stringsFromFollowedUsersQuery setSkip:self.skip];
    }
    
    [stringsFromFollowedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray *strings = [StringrString stringsFromArray:objects];
        [StringrNetworkTask addActivityInfoToStrings:strings completion:^(NSArray *updatedStrings, NSError *error) {
            if (completion) {
                completion(updatedStrings, error);
            }
        }];
    }];
}


#pragma mark - Profile

+ (void)stringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *profileStringsQuery = [self defaultStringQuery];
    [profileStringsQuery whereKey:kStringrStringUserKey equalTo:user];
    [profileStringsQuery orderByDescending:@"createdAt"];
    [profileStringsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([StringrString stringsFromArray:objects], error);
        }
    }];
}


+ (void)likedStringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *likedStringsActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likedStringsActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likedStringsActivityQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    
//    PFQuery *likedStringsQuery = [self defaultStringQuery];
//    [likedStringsQuery whereKey:@"objectId" matchesKey:kStringrActivityStringKey inQuery:likedStringsActivityQuery];
//    [likedStringsQuery orderByDescending:@"createdAt"];
    
    [likedStringsActivityQuery whereKeyExists:kStringrActivityStringKey];
    [likedStringsActivityQuery includeKey:kStringrActivityStringKey];
    [likedStringsActivityQuery orderByDescending:@"createdAt"];
    [likedStringsActivityQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    [likedStringsActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([StringrString stringsFromArray:[self likedStringsFromActivityArray:objects]], error);
        }
    }];
}


+ (NSArray *)likedStringsFromActivityArray:(NSArray *)activities
{
    NSMutableArray *strings = [NSMutableArray new];
    
    for (PFObject *activityObject in activities) {
        PFObject *string = activityObject[kStringrActivityStringKey];
        [string[kStringrStringUserKey] fetchIfNeededInBackground];
        if (string) {
            [strings addObject:string];
        }
    }
    
    return [strings copy];
}

@end
