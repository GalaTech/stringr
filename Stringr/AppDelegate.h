//
//  AppDelegate.h
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrAppController.h"
#import "StringrLoginViewController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrDiscoveryTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, StringrLoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StringrAppController *rootViewController;

@property (nonatomic, readonly) int networkStatus;

- (void)setupLoggedInContent;
- (StringrHomeTabBarViewController *)setupHomeTabBarController;
- (StringrDiscoveryTabBarViewController *)setupDiscoveryTabBarController;
- (BOOL)isParseReachable;

@end
