//
//  StringrUtility.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUtility.h"
#import "UIImage+Resize.h"
#import "StringrNetworkTask+PushNotification.h"

@implementation StringrUtility

#pragma mark - Like/Unlike Photo/String

/*
+ (void)likeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([StringrUtility objectIsString:object]) {
        [self likeStringInBackground:object block:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded, error);
            }
        }];
    } else {
        [self likePhotoInBackground:object block:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded, error);
            }
        }];
    }
}

+ (void)unlikeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([StringrUtility objectIsString:object]) {
        [self unlikeStringInBackground:object block:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded, error);
            }
        }];
    } else {
        [self unlikePhotoInBackground:object block:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded, error);
            }
        }];
    }
}
*/

+ (void)likePhotoInBackground:(PFObject *)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFObject *likeActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [likeActivity setObject:kStringrActivityTypeLike forKey:kStringrActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [likeActivity setObject:[photo objectForKey:kStringrPhotoUserKey] forKey:kStringrActivityToUserKey];
    [likeActivity setObject:photo forKey:kStringrActivityPhotoKey];
    
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [likeACL setWriteAccess:YES forUser:[photo objectForKey:kStringrPhotoUserKey]];
    [likeACL setPublicReadAccess:YES];
    
    [likeActivity setACL:likeACL];
    
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        
        if (succeeded && ![[[photo objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [StringrNetworkTask sendLikedPushNotification:photo];
            
            /*
            // TODO: Set private channel to that of the photo uploader
            NSString *photoUploaderPrivatePushChannel = [[photo objectForKey:kStringrPhotoUserKey] objectForKey:kStringrUserPrivateChannelKey];
            
            if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
                NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
                
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%@ liked your photo!", currentUsernameFormatted], kAPNSAlertKey,
                                      @"Increment", kAPNSBadgeKey,
                                      kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                      kStringrPushPayloadActivityLikeKey, kStringrPushPayloadActivityTypeKey,
                                      [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                      [photo objectId], kStringrPushPayloadPhotoObjectIdKey, @"default", kAPNSSoundKey,
                                      nil];
                
                PFPush *likePhotoPushNotification = [[PFPush alloc] init];
                [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
                [likePhotoPushNotification setData:data];
                [likePhotoPushNotification sendPushInBackground];
            }
             */
        }
    }];
    
}

+ (void)unlikePhotoInBackground:(PFObject *)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [queryExistingLikes whereKey:kStringrActivityPhotoKey equalTo:photo];
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
        } else {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }
    }];
}

/*
+ (void)likeStringInBackground:(PFObject *)string block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFObject *likeActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [likeActivity setObject:kStringrActivityTypeLike forKey:kStringrActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [likeActivity setObject:[string objectForKey:kStringrStringUserKey] forKey:kStringrActivityToUserKey];
    [likeActivity setObject:string forKey:kStringrActivityStringKey];
    
    PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [likeACL setWriteAccess:YES forUser:[string objectForKey:kStringrStringUserKey]];
    [likeACL setPublicReadAccess:YES];
    [likeActivity setACL:likeACL];
    
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
        
        if (succeeded && ![[[string objectForKey:kStringrStringUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            if (succeeded && ![[[string objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                [StringrNetworkTask sendLikedPushNotification:string];
                
                
                // TODO: Set private channel to that of the string uploader
                NSString *stringUploaderPrivatePushChannel = [[string objectForKey:kStringrPhotoUserKey] objectForKey:kStringrUserPrivateChannelKey];
                
                if (stringUploaderPrivatePushChannel && stringUploaderPrivatePushChannel.length != 0) {
                    NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
                    
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%@ liked your string!", currentUsernameFormatted], kAPNSAlertKey,
                                          @"Increment", kAPNSBadgeKey,
                                          kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                          kStringrPushPayloadActivityLikeKey, kStringrPushPayloadActivityTypeKey,
                                          [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                          [string objectId], kStringrPushPayloadStringObjectIDKey, @"default", kAPNSSoundKey,
                                          nil];
                    
                    PFPush *likeStringPushNotification = [[PFPush alloc] init];
                    [likeStringPushNotification setChannel:stringUploaderPrivatePushChannel];
                    [likeStringPushNotification setData:data];
                    [likeStringPushNotification sendPushInBackground];
                }
                
            }
        }
    }];
    
    PFQuery *statisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
    [statisticsQuery whereKey:kStringrStatisticsStringKey equalTo:string];
    [statisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *strings, NSError *error) {
        if (!error) {
            PFObject *stringStatistics = [strings firstObject];
            [stringStatistics incrementKey:kStringrStatisticsLikeCountKey];
            [stringStatistics saveEventually];
        }
    }];
}

+ (void)unlikeStringInBackground:(PFObject *)string block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
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
        } else {
            if (completionBlock) {
                completionBlock(NO, error);
            }
        }
    }];
    
    
    PFQuery *statisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
    [statisticsQuery whereKey:kStringrStatisticsStringKey equalTo:string];
    [statisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *strings, NSError *error) {
        if (!error) {
            PFObject *stringStatistics = [strings firstObject];
            [stringStatistics incrementKey:kStringrStatisticsLikeCountKey byAmount:@(-1)];
            [stringStatistics saveEventually];
        }
    }];
}
*/


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
    [followACL setWriteAccess:YES forUser:user];
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
    [followACL setWriteAccess:YES forUser:user];
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
    NSString *followedUserPrivatePushChannel = [user objectForKey:kStringrUserPrivateChannelKey];
    
    if (followedUserPrivatePushChannel && followedUserPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ is now following you!", currentUsernameFormatted], kAPNSAlertKey,
                              @"Increment", kAPNSBadgeKey,
                              kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                              kStringrPushPayloadActivityFollowKey, kStringrPushPayloadActivityTypeKey,
                              [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                              @"default", kAPNSSoundKey,
                              nil];
        
        PFPush *likeStringPushNotification = [[PFPush alloc] init];
        [likeStringPushNotification setChannel:followedUserPrivatePushChannel];
        [likeStringPushNotification setData:data];
        [likeStringPushNotification sendPushInBackground];
    }
}



#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnObject:(PFObject *)object cachePolicy:(PFCachePolicy)cachePolicy
{
    if ([StringrUtility objectIsString:object]) {
        return [self queryForActivitiesOnString:object cachePolicy:cachePolicy];
    } else {
        return [self queryForActivitiesOnPhoto:object cachePolicy:cachePolicy];
    }
}

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

+ (BOOL)objectIsString:(PFObject *)object
{
    if ([object.parseClassName isEqualToString:kStringrStringClassKey] || [object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
        return [object.parseClassName isEqualToString:kStringrStringClassKey];
    }
    
    return NO;
}



#pragma mark - UIImage Formatting

+ (UIImage *)formatPhotoImageForUpload:(UIImage *)image
{
    // resizes the images for upload
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(314, 314) interpolationQuality:kCGInterpolationHigh];
    
    /*
    // Creates a data representation of the newly selected profile image
    // Saves that image to the current users parse user profile
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    
    
    NSString *photoName = [NSString stringWithFormat:@"%@.jpg", [StringrUtility randomStringWithLength:10]];
    PFFile *imageFile = [PFFile fileWithName:photoName data:imageData];
     */

    return resizedImage;
}

+ (UIImage *)formatProfileImageForUpload:(UIImage *)image
{
    // resizes the images for upload
    UIImage *resizedProfileImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(500, 500) interpolationQuality:kCGInterpolationHigh];
    
    /*
    // Creates a data representation of the newly selected profile image
    // Saves that image to the current users parse user profile
    NSData *profileImageData = UIImageJPEGRepresentation(resizedProfileImage, 0.8f);
    
    
    NSString *photoName = [NSString stringWithFormat:@"%@.jpg", [StringrUtility randomStringWithLength:10]];
    PFFile *profileImageFile = [PFFile fileWithName:photoName data:profileImageData];
    */
     
    return resizedProfileImage;
}

+ (UIImage *)formatProfileThumbnailImageForUpload:(UIImage *)image
{
    // resizes the images for upload
    UIImage *resizedThumbnailImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    
    /*
    // Creates a data representation of the newly selected profile image
    // Saves that image to the current users parse user profile
    NSData *thumbnailImageData = UIImagePNGRepresentation(resizedThumbnailImage);
    
    PFFile *thumbnailImageFile = [PFFile fileWithData:thumbnailImageData];
    */
     
    return resizedThumbnailImage;
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

// Trim the input string by removing leading and trailing white spaces
// and return the result
+ (NSString *)stringTrimmedForLeadingAndTrailingWhiteSpacesFromString:(NSString *)string
{
    NSString *leadingTrailingWhiteSpacesPattern = @"(?:^\\s+)|(?:\\s+$)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:leadingTrailingWhiteSpacesPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSRange stringRange = NSMakeRange(0, string.length);
    NSString *trimmedString = [regex stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:stringRange withTemplate:@"$1"];
    
    return trimmedString;
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

+ (NSString *)usernameFormattedWithMentionSymbol:(NSString *)username
{
    return [NSString stringWithFormat:@"@%@", username];
}

+ (NSString *)randomStringWithLength:(int)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex: arc4random() % letters.length]];
    }
    
    return randomString;
}

+ (CGFloat)heightForLabelWithNSString:(NSString *)text
{
    NSMutableParagraphStyle *textAlignment = [[NSMutableParagraphStyle alloc] init];
    [textAlignment setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName,
                                    textAlignment, NSParagraphStyleAttributeName,
                                    [UIColor darkGrayColor], NSForegroundColorAttributeName,  nil];
    
    CGSize maxLabelSize = CGSizeMake(280, FLT_MAX);
    CGRect rectForLabel = [text boundingRectWithSize:maxLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil];
    
    CGFloat labelHeight = CGRectGetHeight(rectForLabel);
   // CGFloat marginSpace = ((labelHeight / 13) * 3);
    CGFloat cellHeight = labelHeight + ((labelHeight > 100) ? 20 : 15);
    
    return  cellHeight;
}

+ (CGFloat)heightForLabelWithNSString:(NSString *)text labelSize:(CGSize)size andAttributes:(NSDictionary *)attributes
{
    CGSize maxLabelSize = size;
    
    CGRect rectForLabel = [text boundingRectWithSize:maxLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGFloat cellHeight = rectForLabel.size.height;
    
    return  cellHeight;
}

+ (NSArray *)mentionsContainedWithinString:(NSString *)string
{
    NSMutableArray *mentionsInString = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [[string substringWithRange:wordRange] lowercaseString];
        [mentionsInString addObject:word];
    }
    
    return [mentionsInString copy];
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


#pragma mark - String Checking

+ (PFObject *)stringFromObject:(PFObject *)object
{   
    // It's possible for this object to be of type statistic or activity. This just gets the string
    // value from either of those classes
    if ([object.parseClassName isEqualToString:kStringrStringClassKey]) {
        return object;
    }
    else if ([object.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        return [object objectForKey:kStringrStatisticsStringKey];
    }
    else if ([object.parseClassName isEqualToString:kStringrActivityClassKey]) {
        return [object objectForKey:kStringrActivityStringKey];
    }
    else if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
        return [object objectForKey:kStringrPhotoStringKey];
    }
    
    return nil;
}

@end
