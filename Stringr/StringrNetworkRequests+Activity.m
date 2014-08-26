//
//  StringrNetworkRequests+Activity.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkRequests+Activity.h"

@implementation StringrNetworkRequests (Activity)


+ (void)numberOfActivitesForUser:(PFUser *)user completionBlock:(void (^)(NSInteger numberOfActivities, BOOL success))completionBlock
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery countObjectsInBackgroundWithBlock:^(int numberOfActivites, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(numberOfActivites, YES);
            }
        }
        else {
            if (completionBlock) {
                completionBlock(0, NO);
            }
        }
    }];
}


+ (void)activitiesForUser:(PFUser *)user completionBlock:(void (^)(NSArray *activities, BOOL success))completionBlock
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(objects, YES);
            }
        }
        else {
            if (completionBlock) {
                completionBlock(nil, NO);
            }
        }
    }];
}

@end
