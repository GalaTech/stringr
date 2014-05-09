//
//  AppDelegate.h
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrLoginViewController.h"
#import "StringrHomeTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, StringrLoginViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupLoggedInContent;
- (StringrHomeTabBarViewController *)setupHomeTabBarController;

@end
