//
//  StringrNetworkRequests+Activity.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Activity.h"
#import "StringrActivityManager.h"

@implementation StringrNetworkTask (Activity)

+ (void)numberOfActivitesForUser:(PFUser *)user completionBlock:(StringrActivityCountBlock)completionBlock
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery countObjectsInBackgroundWithBlock:^(int numberOfActivites, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(numberOfActivites, error);
            }
            
            if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                [self saveNumberActivitiesForCurrentUser:(NSInteger)numberOfActivites];
            }
        }
        else {
            if (completionBlock) {
                completionBlock(0, error);
            }
        }
    }];
}


+ (void)saveNumberActivitiesForCurrentUser:(NSInteger)numberOfActivities
{
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[StringrActivityManager sharedManager] setNumberOfActivitiesForCurrentUser:numberOfActivities];
        }
    }];
}


+ (void)activitiesForUser:(PFUser *)user completionBlock:(StringrActivitiesBlock)completionBlock
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(objects, error);
            }
        }
        else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}


#pragma mark - Likes and Comments

+ (void)addActivityInfoToStrings:(NSArray *)strings completion:(void (^)(NSArray *updatedStrings, NSError *error))completion
{
    dispatch_group_t group = dispatch_group_create();
    __block NSError *parseError;
    
    for (NSInteger index = 0; index < strings.count; index++) {
        dispatch_group_enter(group);
    }
    
    for (StringrString *string in strings) {
//        [self activityInfoForString:string completion:^(NSInteger likeCount, NSInteger commentCount, BOOL isLikedByCurrentUser, NSError *error) {
////            string.likeCount = likeCount;
////            string.commentCount = commentCount;
//            string.isLikedByCurrentUser = isLikedByCurrentUser;
//            
//            parseError = error;
//            
//            dispatch_group_leave(group);
//        }];
        
        [self isString:string likedByUser:[PFUser currentUser] completion:^(BOOL isLiked, NSError *error) {
            string.isLikedByCurrentUser = isLiked;
            
            parseError = error;
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) {
            completion([strings copy], parseError);
        }
    });
}


+ (void)activityInfoForString:(StringrString *)string completion:(StringrActivityDetailsBlock)completion
{
    __block NSInteger likeCount = 0;
    __block BOOL isLikedByUser = NO;
    __block NSInteger commentCount = 0;
    __block NSError *parseError;
    
    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
//    [self statisticsForString:string completion:^(PFObject *stringStatistic, NSError *error) {
//        if (!error) {
//            likeCount = [stringStatistic[kStringrStatisticsLikeCountKey] integerValue];
//            commentCount = [stringStatistic[kStringrStatisticsCommentCountKey] integerValue];
//        }
//        
//        parseError = error;
//        
//        dispatch_group_leave(group);
//    }];
    
    dispatch_group_enter(group);
    [self isString:string likedByUser:[PFUser currentUser] completion:^(BOOL isLiked, NSError *error) {
        if (!error) {
            isLikedByUser = isLiked;
        }
        
        parseError = error;
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(likeCount, commentCount, isLikedByUser, parseError);
        }
    });
}


+ (void)isString:(StringrString *)string likedByUser:(PFUser *)user completion:(void (^)(BOOL isLiked, NSError * error))completion
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [activityQuery whereKey:kStringrActivityStringKey equalTo:string.parseString];
    [activityQuery whereKey:kStringrActivityFromUserKey equalTo:user];
    [activityQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (completion) {
            completion(number > 0, error);
        }
    }];
}


+ (void)statisticsForString:(StringrString *)string completion:(void (^)(PFObject *stringStatistic, NSError *error))completion
{
    PFQuery *statisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
    [statisticsQuery whereKey:kStringrStatisticsStringKey equalTo:string.parseString];
    [statisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion([objects firstObject], error);
        }
    }];
}

+ (void)numberOfLikesForString:(StringrString *)string completion:(StringrActivityCountBlock)completion
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [activityQuery whereKey:kStringrActivityStringKey equalTo:string.parseString];
    [activityQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (completion) {
            completion(number, error);
        }
    }];
}


+ (void)likesForString:(StringrString *)string completionBlock:(StringrActivitiesBlock)completionBlock
{
    
}


+ (void)numberofCommentsForString:(StringrString *)string completion:(StringrActivityCountBlock)completion
{
    PFQuery *commentQuery = [PFQuery queryWithClassName:kStringrActivityCommentKey];
    [commentQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
    [commentQuery whereKey:kStringrActivityStringKey equalTo:string.parseString];
    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (completion) {
            completion(number, error);
        }
    }];
}


+ (void)commentsForString:(StringrString *)string completionBlock:(StringrActivitiesBlock)completionBlock
{
    
}

@end
