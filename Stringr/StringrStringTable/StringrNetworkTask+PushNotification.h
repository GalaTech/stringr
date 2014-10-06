//
//  StringrNetworkTask+PushNotification.h
//  Stringr
//
//  Created by Jonathan Howard on 10/5/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@interface StringrNetworkTask (PushNotification)

+ (void)sendFollowingPushNotification:(PFUser *)user;
+ (void)sendLikedPushNotification:(PFObject *)object;
+ (void)sendCommentPushNotification:(PFObject *)object comment:(PFObject *)comment;
+ (void)sendMentionPushNotification:(PFObject *)object;
+ (void)sendContributedPushNotification:(PFObject *)object;

@end
