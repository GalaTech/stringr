//
//  StringrNetworkRequests+Activity.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkRequests.h"

@interface StringrNetworkRequests (Activity)

+ (void)numberOfActivitesForUser:(PFUser *)user completionBlock:(void (^)(NSInteger numberOfActivities, BOOL success))completionBlock;
+ (void)activitiesForUser:(PFUser *)user completionBlock:(void (^)(NSArray *activities, BOOL success))completionBlock;

@end
