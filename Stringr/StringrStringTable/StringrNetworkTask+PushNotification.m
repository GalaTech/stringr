//
//  StringrNetworkTask+PushNotification.m
//  Stringr
//
//  Created by Jonathan Howard on 10/5/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+PushNotification.h"

@interface StringrNetworkTask ()

@end

@implementation StringrNetworkTask (PushNotification)

#pragma mark - Follow

+ (void)sendFollowingPushNotification:(PFUser *)user
{
    NSString *followedUserPrivatePushChannel = [user objectForKey:kStringrUserPrivateChannelKey];
    
    if (followedUserPrivatePushChannel && followedUserPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ followed you!", currentUsernameFormatted], kAPNSAlertKey,
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


#pragma mark - Like

+ (void)sendLikedPushNotification:(PFObject *)object
{
    StringrObjectType objectType = [self objectType:object];
    
    if (objectType == StringrStringType) {
        [self sendLikedStringPushNotification:object];
    }
    else if (objectType == StringrPhotoType) {
        [self sendLikedPhotoPushNotification:object];
    }
}


+ (void)sendLikedStringPushNotification:(PFObject *)string
{
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


+ (void)sendLikedPhotoPushNotification:(PFObject *)photo
{
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
}


#pragma mark - Comment

+ (void)sendCommentPushNotification:(PFObject *)object comment:(PFObject *)comment
{
    NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
    
    NSString *alert = @"";
//    // String with the commenters name and the comment
//    NSString *alert = [NSString stringWithFormat:@"%@: %@", currentUsernameFormatted, [comment objectForKey:kStringrActivityContentKey]];
//    
//    // make sure to leave enough space for payload overhead
//    if (alert.length > 100) {
//        alert = [alert substringToIndex:89];
//        alert = [alert stringByAppendingString:@"…"];
//    }
    
    StringrObjectType objectType = [self objectType:object];
    
    if (objectType == StringrStringType) {
        alert = [NSString stringWithFormat:@"%@ commented on your String!", currentUsernameFormatted];
        [self sendStringCommentPushNotification:object alert:alert];
    }
    else if (objectType == StringrPhotoType) {
        alert = [NSString stringWithFormat:@"%@ commented on your photo!", currentUsernameFormatted];
        [self sendPhotoCommentPushNotification:object alert:alert];
    }
}


+ (void)sendStringCommentPushNotification:(PFObject *)string alert:(NSString *)alert
{
    if (![[[string objectForKey:kStringrStringUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && [StringrUtility objectIsString:string]) {
        
        NSString *photoUploaderPrivatePushChannel = [[string objectForKey:kStringrStringUserKey] objectForKey:kStringrUserPrivateChannelKey];
        
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"Increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [string objectId], kStringrPushPayloadStringObjectIDKey,
                                  @"default", kAPNSSoundKey,
                                  nil];
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    }
}


+ (void)sendPhotoCommentPushNotification:(PFObject *)photo alert:(NSString *)alert
{
    if (![[[photo objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && ![StringrUtility objectIsString:photo]) {
        NSString *photoUploaderPrivatePushChannel = [[photo objectForKey:kStringrPhotoUserKey] objectForKey:kStringrUserPrivateChannelKey];
        
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"Increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [photo objectId], kStringrPushPayloadPhotoObjectIdKey,
                                  @"default", kAPNSSoundKey,
                                  nil];
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    }
}



#pragma mark - Mention

+ (void)sendMentionPushNotificationToUser:(PFUser *)user withObject:(PFObject *)object
{
    StringrObjectType objectType = [self objectType:object];
    
    if (objectType == StringrStringType) {
        [self sendMentionPushNotificationToUser:user withString:object];
    }
    else if (objectType == StringrPhotoType) {
        [self sendMentionPushNotificationToUser:user withPhoto:object];
    }
    else if (objectType == StringrCommentType) {
        [self sendMentionPushNotificationToUser:user withComment:object];
    }
}


+ (void)sendMentionPushNotificationToUser:(PFUser *)user withString:(PFObject *)string
{
    NSString *uploaderPrivatePushChannel = [user objectForKey:kStringrUserPrivateChannelKey];
    
    if (uploaderPrivatePushChannel && uploaderPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ mentioned you in their String!", currentUsernameFormatted], kAPNSAlertKey,
                              @"Increment", kAPNSBadgeKey,
                              kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                              kStringrActivityTypeMention, kStringrPushPayloadActivityTypeKey,
                              [user objectId], kStringrPushPayloadToUserObjectIdKey,
                              [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                              [string objectId], kStringrPushPayloadPhotoObjectIdKey,
                              @"default", kAPNSSoundKey,
                              nil];
        
        PFPush *stringMentionPushNotification = [[PFPush alloc] init];
        [stringMentionPushNotification setChannel:uploaderPrivatePushChannel];
        [stringMentionPushNotification setData:data];
        [stringMentionPushNotification sendPushInBackground];
    }
}


+ (void)sendMentionPushNotificationToUser:(PFUser *)user withPhoto:(PFObject *)photo
{
    NSString *photoUploaderPrivatePushChannel = [user objectForKey:kStringrUserPrivateChannelKey];
    
    if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ mentioned you in their photo!", currentUsernameFormatted], kAPNSAlertKey,
                              @"Increment", kAPNSBadgeKey,
                              kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                              kStringrActivityTypeMention, kStringrPushPayloadActivityTypeKey,
                              [user objectId], kStringrPushPayloadToUserObjectIdKey,
                              [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                              [photo objectId], kStringrPushPayloadPhotoObjectIdKey,
                              @"default", kAPNSSoundKey,
                              nil];
        
        PFPush *photoMentionPushNotification = [[PFPush alloc] init];
        [photoMentionPushNotification setChannel:photoUploaderPrivatePushChannel];
        [photoMentionPushNotification setData:data];
        [photoMentionPushNotification sendPushInBackground];
    }
}


+ (void)sendMentionPushNotificationToUser:(PFUser *)user withComment:(PFObject *)comment
{
    PFUser *commentedObjectUser;
    
    if ([comment objectForKey:kStringrActivityStringKey]) {
        PFObject *commentedString = [comment objectForKey:kStringrActivityStringKey];
        commentedObjectUser = [commentedString objectForKey:kStringrStringUserKey];
    }
    else if ([comment objectForKey:kStringrActivityPhotoKey]) {
        PFObject *commentedPhoto = [comment objectForKey:kStringrActivityPhotoKey];
        commentedObjectUser = [commentedPhoto objectForKey:kStringrPhotoUserKey];
    }
    
    if ([user.objectId isEqualToString:commentedObjectUser.objectId]) return;
    
    NSString *uploaderPrivatePushChannel = [user objectForKey:kStringrUserPrivateChannelKey];
    
    if (uploaderPrivatePushChannel && uploaderPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ mentioned you in their comment!", currentUsernameFormatted], kAPNSAlertKey,
                              @"Increment", kAPNSBadgeKey,
                              kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                              kStringrActivityTypeMention, kStringrPushPayloadActivityTypeKey,
                              [user objectId], kStringrPushPayloadToUserObjectIdKey,
                              [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                              [comment objectId], kStringrPushPayloadCommentObjectIDKey,
                              @"default", kAPNSSoundKey,
                              nil];
        
        PFPush *commentMentionPushNotification = [[PFPush alloc] init];
        [commentMentionPushNotification setChannel:uploaderPrivatePushChannel];
        [commentMentionPushNotification setData:data];
        [commentMentionPushNotification sendPushInBackground];
    }
}


#pragma mark - Contributed

+ (void)sendContributedToStringPushNotification:(PFObject *)string withPhoto:(PFObject *)photo
{
    NSString *uploaderPrivatePushChannel = [[string objectForKey:kStringrPhotoUserKey] objectForKey:kStringrUserPrivateChannelKey];
    
    if (uploaderPrivatePushChannel && uploaderPrivatePushChannel.length != 0) {
        NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ added a photo to your String!", currentUsernameFormatted], kAPNSAlertKey,
                              @"Increment", kAPNSBadgeKey,
                              kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                              kStringrActivityTypeAddedPhotoToPublicString, kStringrPushPayloadActivityTypeKey,
                              [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                              [photo objectId], kStringrPushPayloadPhotoObjectIdKey,
                              [string objectId], kStringrPushPayloadStringObjectIDKey,
                              @"default", kAPNSSoundKey,
                              nil];
        
        PFPush *contributedToStringPushNotification = [[PFPush alloc] init];
        [contributedToStringPushNotification setChannel:uploaderPrivatePushChannel];
        [contributedToStringPushNotification setData:data];
        [contributedToStringPushNotification sendPushInBackground];
    }
}


@end
