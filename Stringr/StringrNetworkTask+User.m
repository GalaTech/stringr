//
//  StringrNetworkRequests+User.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+User.h"

@implementation StringrNetworkTask (User)

#pragma mark - Login Authentication

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
