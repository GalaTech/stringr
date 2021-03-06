//
//  StringrNetworkRequests+User.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@interface StringrNetworkTask (User)

+ (BOOL)facebookUserCanLogin:(PFUser *)facebookUser;
+ (BOOL)twitterUserCanLogin:(PFUser *)twitterUser;
+ (BOOL)usernameUserCanLogin:(PFUser *)usernameUser;
+ (BOOL)usernameUserNeedsToVerifyEmail:(PFUser *)usernameUser;

@end
