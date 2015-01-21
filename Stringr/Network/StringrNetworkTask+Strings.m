//
//  StringrNetworkTask+Strings.m
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Strings.h"

@implementation StringrNetworkTask (Strings)

+ (void)homeFeedForUser:(PFUser *)user completion:(StringrStringsBlock)completion
{
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:1000];

    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([objects copy], error);
        }
    }];
}

@end
