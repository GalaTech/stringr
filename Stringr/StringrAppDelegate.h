//
//  AppDelegate.h
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrAppViewController.h"
#import "StringrLoginViewController.h"
#import "StringrDashboardTabBarController.h"

@interface StringrAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) StringrAppViewController *appViewController;

@end


@interface UIApplication (StringrAppDelegate)

+ (StringrAppDelegate *)appDelegate;

@end