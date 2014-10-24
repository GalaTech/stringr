//
//  StringrNetworkTask+LikeActivity.m
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+LikeActivity.h"
#import "StringrNetworkTask+PushNotification.h"

@implementation StringrNetworkTask (LikeActivity)

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
                
                /*
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
                 */
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


@end
