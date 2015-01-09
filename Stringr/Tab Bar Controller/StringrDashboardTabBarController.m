//
//  StringrHomeTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDashboardTabBarController.h"
#import "StringrActivityTableViewController.h"
#import "StringrNetworkTask+Activity.h"

#import "StringrNavigationController.h"
#import "StringrFollowingTableViewController.h"

#import "StringrProfileViewController.h"
#import "StringrExploreViewController.h"

#import "StringrActivityManager.h"
#import "UIColor+StringrColors.h"
#import "UIImage+StringrImageAdditions.h"

@implementation StringrDashboardTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDashboardViewControllers];
    [self setupAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActivityNotificationsTabValue) name:@"currentUserHasNewActivities" object:nil];
}


#pragma mark - Private

- (void)setupDashboardViewControllers
{
    StringrFollowingTableViewController *followingVC = [StringrFollowingTableViewController new];
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    StringrExploreViewController *exploreVC = [StringrExploreViewController viewController];
    StringrNavigationController *exploreNavVC = [[StringrNavigationController alloc] initWithRootViewController:exploreVC];
    UITabBarItem *exploreTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [exploreVC setTabBarItem:exploreTab];
    
    UIViewController *cameraVC = [UIViewController new];
    UITabBarItem *cameraTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"camera_button"] tag:0];
    [cameraVC setTabBarItem:cameraTab];
    
    StringrActivityTableViewController *activityVC = [StringrActivityTableViewController viewController];
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"activity_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
    profileVC.userForProfile = [PFUser currentUser];
    profileVC.isDashboardProfile = YES;
    StringrNavigationController *profileNavVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    profileNavVC.navigationBar.tintColor = [UIColor whiteColor];
    profileNavVC.navigationBar.translucent = NO;
    UITabBarItem *profileTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"users_icon"] tag:0];
    [profileVC setTabBarItem:profileTab];
    
    [self setViewControllers:@[followingNavVC, exploreNavVC, cameraVC, activityNavVC, profileNavVC]];
}


- (void)setupAppearance
{
    [self.tabBar setTintColor:[UIColor grayColor]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        item.image = [[item.selectedImage tintedImageUsingColor:[UIColor stringrTabBarItemColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}


#pragma mark - Activity

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"Activity"]) {
        item.badgeValue = nil;
    }
}


- (void)updateActivityNotificationsTabValue
{
    NSInteger numberOfNewActivities = [[StringrActivityManager sharedManager] numberOfNewActivitiesForCurrentUser];
    
    if (numberOfNewActivities > 0) {
        UITabBarItem *activityTab = self.viewControllers[3];
        [activityTab setBadgeValue:[NSString stringWithFormat:@"%ld", (long)numberOfNewActivities]];
    }
}

@end
