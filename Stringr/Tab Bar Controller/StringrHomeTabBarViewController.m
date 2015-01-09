//
//  StringrHomeTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrNetworkTask+Activity.h"

#import "StringrNavigationController.h"
#import "StringrFollowingTableViewController.h"

#import "StringrProfileViewController.h"
#import "StringrExploreViewController.h"

#import "StringrActivityManager.h"
#import "UIColor+StringrColors.h"

@implementation StringrHomeTabBarViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        StringrFollowingTableViewController *followingVC = [StringrFollowingTableViewController new];
        StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
        UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
        [followingNavVC setTabBarItem:followingTab];
        
        StringrExploreViewController *exploreVC = [StringrExploreViewController viewController];
        StringrNavigationController *exploreNavVC = [[StringrNavigationController alloc] initWithRootViewController:exploreVC];
        UITabBarItem *exploreTab = [[UITabBarItem alloc] initWithTitle:@"Explore" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
        [exploreVC setTabBarItem:exploreTab];
        
        UIViewController *cameraVC = [UIViewController new];
        UITabBarItem *cameraTab = [[UITabBarItem alloc] initWithTitle:@"Camera" image:[UIImage imageNamed:@"camera_button"] tag:0];
        [cameraVC setTabBarItem:cameraTab];
        
        StringrActivityTableViewController *activityVC = [StringrActivityTableViewController viewController];
        StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
        UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activity_icon"] tag:0];
        [activityNavVC setTabBarItem:activityTab];
        
        StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
        profileVC.userForProfile = [PFUser currentUser];
        profileVC.isDashboardProfile = YES;
        StringrNavigationController *profileNavVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        UITabBarItem *profileTab = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"users_icon"] tag:0];
        [profileVC setTabBarItem:profileTab];
        
        [self setViewControllers:@[followingNavVC, exploreNavVC, cameraVC, activityNavVC, profileNavVC]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActivityNotificationsTabValue) name:@"currentUserHasNewActivities" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setTintColor:[UIColor stringrLogoBlueColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [StringrNetworkTask activitiesForUser:[PFUser currentUser] completionBlock:nil];
}

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
        UITabBarItem *activityTab = [[self.viewControllers lastObject] tabBarItem];
        [activityTab setBadgeValue:[NSString stringWithFormat:@"%ld", (long)numberOfNewActivities]];
    }
}


@end
