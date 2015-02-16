//
//  StringrNetworkTask+Profile.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Profile.h"

@implementation StringrNetworkTask (Profile)

#pragma mark - User's Strings

+ (void)stringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *profileStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [profileStringsQuery whereKey:kStringrStringUserKey equalTo:user];
    [profileStringsQuery orderByDescending:@"createdAt"];
    [profileStringsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
}


#pragma mark - Liked Strings

+ (void)likedStringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *likedStringsQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likedStringsQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likedStringsQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [likedStringsQuery whereKeyExists:kStringrActivityStringKey];
    [likedStringsQuery includeKey:kStringrActivityStringKey];
    [likedStringsQuery orderByDescending:@"createdAt"];
    [likedStringsQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    [likedStringsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([self likedStringsFromActivityArray:objects], error);
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


#pragma mark - Liked Photos

//+ (void)likedPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
//{
//    PFQuery *likePhotosActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
//    [likePhotosActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
//    [likePhotosActivityQuery whereKey:kStringrActivityFromUserKey equalTo:user];
//    [likePhotosActivityQuery whereKeyExists:kStringrActivityPhotoKey];
//    [likePhotosActivityQuery includeKey:kStringrActivityPhotoKey];
//    [likePhotosActivityQuery orderByDescending:@"createdAt"];
//    [likePhotosActivityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
//    [likePhotosActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (completion) {
//            completion([self likedPhotosFromActivityArray:objects], error);
//        }
//    }];
//}


//+ (NSArray *)likedPhotosFromActivityArray:(NSArray *)actitvities
//{
//    NSMutableArray *photos = [NSMutableArray new];
//    
//    for (PFObject *activityObject in actitvities) {
//        PFObject *photo = [activityObject objectForKey:kStringrActivityPhotoKey];
//        if (photo) {
//            [photos addObject:photo];
//        }
//        
//        // fetches the photos associated String object for future photo owner functionality
//        PFObject *string = [[activityObject objectForKey:kStringrActivityPhotoKey] objectForKey:kStringrPhotoStringKey];
//        if (string) {
//            [string fetchIfNeededInBackgroundWithBlock:nil];
//        }
//    }
//    
//    return [photos copy];
//}


#pragma mark - User's public photos

//+ (void)publicPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
//{
//    PFQuery *publicPhotosQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
//    [publicPhotosQuery whereKey:kStringrActivityFromUserKey equalTo:user];
//    [publicPhotosQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeAddedPhotoToPublicString];
//    [publicPhotosQuery whereKeyExists:kStringrActivityPhotoKey];
//    [publicPhotosQuery includeKey:kStringrActivityPhotoKey];
//    [publicPhotosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (completion) {
//            completion([self likedPhotosFromActivityArray:objects], error);
//        }
//    }];
//}

@end