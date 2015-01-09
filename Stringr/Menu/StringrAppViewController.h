//
//  StringrAppViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrViewController.h"
#import "StringrLoginViewController.h"

@interface StringrAppViewController : UIViewController <StringrViewController, StringrLoginViewControllerDelegate>

@property (strong, nonatomic, readonly) UIViewController *currentContentViewController;

- (void)transitionToLoginViewController:(BOOL)animated;
- (void)transitionToDashboardViewController:(BOOL)animated;

- (void)signup;
- (void)logout;

- (void)launchSequence:(NSDictionary *)launchOptions;
- (BOOL)isParseReachable;

@end
