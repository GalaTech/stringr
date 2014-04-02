//
//  StringrUtility.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUtility.h"

@implementation StringrUtility


#pragma mark - Like/Unlike Photo/String

+ (void)likePhotoInBackground:(PFObject *)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    [photo incrementKey:kStringrPhotoNumberOfLikesKey];
    
    // remove any existing likes the current user has on the specified photo
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryExistingLikes whereKey:kStringrActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [queryExistingLikes whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (!error) {
            for (PFObject *activity in likes) {
                [activity delete]; // maybe delete in background?
            }
        }
    }];
    
    PFObject *likeActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [likeActivity setObject:kStringrActivityTypeLike forKey:kStringrActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [likeActivity setObject:[photo objectForKey:kStringrPhotoUserKey] forKey:kStringrActivityToUserKey];
    [likeActivity setObject:photo forKey:kStringrActivityPhotoKey];
    
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [likeACL setPublicReadAccess:YES];
    
    [likeActivity setACL:likeACL];
    
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        
        if (succeeded && ![[[photo objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            // send push notification to photo uploader
        }
        
        // refresh sharedCache
    }];
    
}

+ (void)unlikePhotoInBackground:(PFObject *)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    [photo incrementKey:kStringrPhotoNumberOfLikesKey byAmount:@(-1)];
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryExistingLikes whereKey:kStringrActivityPhotoKey equalTo:photo];
    [queryExistingLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [queryExistingLikes whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (!error) {
            for (PFObject *activity in likes) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES, nil);
            }
            
            // refresh cache
        } else {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }
    }];
}

+ (void)likeStringInBackground:(PFObject *)string block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    [string incrementKey:kStringrStringNumberOfLikesKey byAmount:@(1)];
    [string saveInBackground];
    
    
    // remove any existing likes the current user has on the specified photo
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryExistingLikes whereKey:kStringrActivityPhotoKey equalTo:string];
    [queryExistingLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [queryExistingLikes whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (!error) {
            for (PFObject *activity in likes) {
                [activity deleteInBackground]; // maybe delete in background?
            }
        }
        
    }]; // I moved this closing bracket up here instead of encapsulating all the code in this method.
        // it was saving two likes every time if I had it the later.
     
    
    PFObject *likeActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [likeActivity setObject:kStringrActivityTypeLike forKey:kStringrActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [likeActivity setObject:[string objectForKey:kStringrStringUserKey] forKey:kStringrActivityToUserKey];
    [likeActivity setObject:string forKey:kStringrActivityStringKey];
    
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [likeACL setPublicReadAccess:YES];
    [likeActivity setACL:likeACL];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        
        
        if (succeeded && ![[[string objectForKey:kStringrStringUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            // send push notification to photo uploader
        }
        
        
        // refresh sharedCache
    }];
}

+ (void)unlikeStringInBackground:(PFObject *)string block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    [string incrementKey:kStringrStringNumberOfLikesKey byAmount:@(-1)];
    [string saveInBackground];
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryExistingLikes whereKey:kStringrActivityStringKey equalTo:string];
    [queryExistingLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [queryExistingLikes whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (!error) {
            for (PFObject *activity in likes) {
                [activity deleteInBackground];
            }
            
            if (completionBlock) {
                completionBlock(YES, nil);
            }
            
            // refresh cache
            
        } else {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }
    }];
}




#pragma mark - Follow/Unfollow Users

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [followActivity setObject:user forKey:kStringrActivityToUserKey];
    [followActivity setObject:kStringrActivityTypeFollow forKey:kStringrActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        
        if (succeeded) {
            [StringrUtility sendFollowingPushNotification:user];
        }
    }];
    
    //[[StringrCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [followActivity setObject:user forKey:kStringrActivityToUserKey];
    [followActivity setObject:kStringrActivityTypeFollow forKey:kStringrActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    //[[StringrCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    for (PFUser *user in users) {
        [StringrUtility followUserEventually:user block:completionBlock];
        //[[StringrCache sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [query whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kStringrActivityToUserKey equalTo:user];
    [query whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    //[[StringrCache sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users
{
    PFQuery *query = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [query whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kStringrActivityToUserKey containedIn:users];
    [query whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (PFObject *activity in activities) {
            [activity deleteEventually];
        }
    }];
    
    /*
    for (PFUser *user in users) {
        [[StringrCache sharedCache] setFollowStatus:NO user:user];
    }
     */
}




#pragma mark - Push Notification's

+ (void)sendFollowingPushNotification:(PFUser *)user
{
    NSString *privateChannelName = [user objectForKey:kStringrUserPrivateChannelKey];
    if (privateChannelName && privateChannelName.length != 0) {
        /*
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ is now following you!", [StringrUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]]], kAPNSAlertKey,
                              kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                              kPAPPushPayloadActivityFollowKey, kPAPPushPayloadActivityTypeKey,
                              [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
                              nil];
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:privateChannelName];
        [push setData:data];
        [push sendPushInBackground];
         */
    }
}




#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy
{
    PFQuery *queryLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryLikes whereKey:kStringrActivityPhotoKey equalTo:photo];
    [queryLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryComments whereKey:kStringrActivityPhotoKey equalTo:photo];
    [queryComments whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryLikes, queryComments]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kStringrActivityFromUserKey];
    [query includeKey:kStringrActivityPhotoKey];
    
    return query;
}

+ (PFQuery *)queryForActivitiesOnString:(PFObject *)string cachePolicy:(PFCachePolicy)cachePolicy
{
    PFQuery *queryLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryLikes whereKey:kStringrActivityStringKey equalTo:string];
    [queryLikes whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryComments whereKey:kStringrActivityStringKey equalTo:string];
    [queryComments whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryLikes, queryComments]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kStringrActivityFromUserKey];
    [query includeKey:kStringrActivityStringKey];
    
    return query;
}





#pragma mark - Menu

+ (void)showMenu:(REFrostedViewController *)menuViewController
{
    [menuViewController presentMenuViewController];
}





#pragma mark - Text Parsing

//static float const secondsRemovedFromDate = 240;
+ (NSString *)timeAgoFromDate:(NSDate *)date
{
    if (date) {
        // I add 4 mintues to the time so that it compensates for the off-time from parse
        //NSDate *newDate = [date dateByAddingTimeInterval:secondsRemovedFromDate];
        
        NSCalendarUnit units =  NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                       fromDate:date
                                                                         toDate:[NSDate date]
                                                                        options:0];
        
        if (components.year >= 1) {
            NSString *yearLabel = @"Years";
            
            if (components.year == 1) {
                yearLabel = @"Year";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.year, yearLabel];
            //NSLog(@"%@", yearsAgoText);
        } else if (components.month >= 1) {
            NSString *monthLabel = @"Months";
            
            if (components.month == 1) {
                monthLabel = @"Month";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.month, monthLabel];
            //NSLog(@"%@", monthsAgoText);
        } else if (components.weekOfYear >= 1) {
            NSString *weekLabel = @"Weeks";
            
            if (components.weekOfYear == 1) {
                weekLabel = @"Week";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.weekOfYear, weekLabel];
            //NSLog(@"%@", weeksAgoText);
        } else if (components.day >= 1) {
            NSString *dayLabel = @"Days";
            
            if (components.day == 1) {
                dayLabel = @"Day";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.day, dayLabel];
            //NSLog(@"%@", daysAgoText);
        } else if (components.hour >= 1) {
            NSString *hourLabel = @"Hours";
            
            if (components.hour == 1) {
                hourLabel = @"Hour";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.hour, hourLabel];
            //NSLog(@"%@", hoursAgoText);
        } else if (components.minute >= 1) {
            NSString *minuteLabel = @"Minutes";
            
            if (components.minute == 1) {
                minuteLabel = @"Minute";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.minute, minuteLabel];
            //NSLog(@"%@", minutesAgoText);
        } else if (components.second <= 60) {
            NSString *secondLabel = @"Seconds";
            
            if (components.second == 1) {
                secondLabel = @"Second";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.second, secondLabel];
            //NSLog(@"%@", secondsAgoText);
        } else {
            return @"Uploaded in the Past!";
        }
    } else {
        return @"No Date";
    }
}

+ (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)NSStringContainsCharactersWithoutWhiteSpace:(NSString *)checkString
{
    NSCharacterSet *noCharacters = [NSCharacterSet whitespaceCharacterSet];
    NSArray *textWords = [checkString componentsSeparatedByCharactersInSet:noCharacters];
    NSString *textWithoutWhiteSpace = [textWords componentsJoinedByString:@""];
    
    if (textWithoutWhiteSpace.length > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)NSStringIsValidUsername:(NSString *)checkString
{
    if ([self NSStringContainsCharactersWithoutWhiteSpace:checkString] && checkString.length > 0 && checkString.length <= 15) {
        // This string dictates what characters are valid to use for creating a username.
        // This uses some set expressions and regular expression operators. http://userguide.icu-project.org/strings/regexp
        NSString *validCharacters = @"[A-Z0-9a-z._-]+?";
        NSPredicate *validCharactersTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validCharactersTest evaluateWithObject:checkString];
    }
    
    return NO;
}




#pragma mark - Login

+ (BOOL)facebookUserCanLogin:(PFUser *)facebookUser
{
    return facebookUser && [PFFacebookUtils isLinkedWithUser:facebookUser] && [[facebookUser objectForKey:kStringrUserSocialNetworkSignupCompleteKey] boolValue] == YES;
}

+ (BOOL)twitterUserCanLogin:(PFUser *)twitterUser
{
    return twitterUser && [PFTwitterUtils isLinkedWithUser:twitterUser] && [[twitterUser objectForKey:kStringrUserSocialNetworkSignupCompleteKey] boolValue] == YES;
}

+ (BOOL)usernameUserCanLogin:(PFUser *)usernameUser
{
    return usernameUser && [[usernameUser objectForKey:kStringrUserEmailVerifiedKey] boolValue] == YES && ![PFFacebookUtils isLinkedWithUser:usernameUser] && ![PFTwitterUtils isLinkedWithUser:usernameUser];
}

+ (BOOL)usernameUserNeedsToVerifyEmail:(PFUser *)usernameUser
{
    return usernameUser && [[usernameUser objectForKey:kStringrUserEmailVerifiedKey] boolValue] == NO && [PFFacebookUtils isLinkedWithUser:usernameUser] == NO && [PFTwitterUtils isLinkedWithUser:usernameUser] == NO;
}

@end
