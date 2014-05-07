//
//  StringrSignUpWithSocialNetworkViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 3/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSignUpWithEmailTableViewController.h"
#import "StringrLoginViewController.h"

typedef enum {
    FacebookNetworkType = 0,
    TwitterNetworkType = 1
} SocialNetworkType;

@interface StringrSignUpWithSocialNetworkViewController : StringrSignUpWithEmailTableViewController <StringrLoginViewControllerDelegate>

@property (nonatomic) SocialNetworkType networkType;
@property (strong, nonatomic) NSString *twitterScreenName;

@end
