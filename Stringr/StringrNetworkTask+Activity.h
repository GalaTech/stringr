//
//  StringrNetworkRequests+Activity.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

typedef void (^StringrActivityDetailsBlock)(NSInteger likeCount, NSInteger commentCount, BOOL isLikedByCurrentUser, NSError *error);
typedef void (^StringrActivityCountBlock)(NSInteger count, NSError *error);
typedef void (^StringrActivitiesBlock)(NSArray *activities, NSError *error);

@interface StringrNetworkTask (Activity)

+ (void)numberOfActivitesForUser:(PFUser *)user completionBlock:(StringrActivityCountBlock)completionBlock;
+ (void)activitiesForUser:(PFUser *)user completionBlock:(StringrActivitiesBlock)completionBlock;

+ (void)addActivityInfoToStrings:(NSArray *)strings completion:(void (^)(NSArray *updatedStrings, NSError *error))completion;

+ (void)activityInfoForString:(StringrString *)string completion:(StringrActivityDetailsBlock)completion;

+ (void)isString:(StringrString *)string likedByUser:(PFUser *)user completion:(void (^)(BOOL isLiked, NSError * error))completion;

+ (void)numberOfLikesForString:(StringrString *)string completion:(StringrActivityCountBlock)completion;
+ (void)likesForString:(StringrString *)string completionBlock:(StringrActivitiesBlock)completionBlock;

+ (void)numberofCommentsForString:(StringrString *)string completion:(StringrActivityCountBlock)completion;
+ (void)commentsForString:(StringrString *)string completionBlock:(StringrActivitiesBlock)completionBlock;

@end
