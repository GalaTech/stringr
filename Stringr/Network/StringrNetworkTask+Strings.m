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

@implementation StringrNetworkTask (Strings)

#pragma mark - General

+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType completion:(StringrStringsBlock)completion
{
    if (completion) {
        [self stringsForDataType:dataType user:[PFUser currentUser] completion:completion];
    }
}

+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrStringsBlock)completion
{
    if (completion) {
        switch (dataType) {
            case StringrUserStringsNetworkTask:
                [StringrNetworkTask stringsForUser:user completion:completion];
                break;
            case StringrFollowingNetworkTask:
                [StringrNetworkTask homeFeedForUser:user completion:completion];
                break;
            case StringrLikedStringsNetworkTask:
                [StringrNetworkTask likedStringsForUser:user completion:completion];
            default:
                break;
        }
    }
}


#pragma mark - Dashboard

+ (void)homeFeedForUser:(PFUser *)user completion:(StringrStringsBlock)completion
{
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:5];

    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([objects copy], error);
        }
    }];
}

@end
