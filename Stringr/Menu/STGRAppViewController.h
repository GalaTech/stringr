//
//  StringrAppViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrViewController.h"
#import "StringrDashboardTabBarController.h"

@interface STGRAppViewController : UIViewController <StringrViewController>

@property (strong, nonatomic, readonly) UIViewController *currentContentViewController;

// Navigation
- (void)transitionToLoginViewController:(BOOL)animated;
- (void)transitionToDashboardViewController:(BOOL)animated;
- (void)transitionToDashboardTabIndex:(DashboardTabIndex)index;
- (void)transitionToStringCreator:(BOOL)animated;

// User State
- (void)signup;
- (void)logout;

// Networking
- (BOOL)isParseReachable;

@end
