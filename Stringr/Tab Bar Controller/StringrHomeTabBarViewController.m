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

#import "StringrActivityManager.h"
#import "UIColor+StringrColors.h"

@implementation StringrHomeTabBarViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StringrFollowingTableViewController *followingVC = [StringrFollowingTableViewController new];
        StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
        UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
        [followingNavVC setTabBarItem:followingTab];
        
        StringrActivityTableViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardActivityTableID];
        StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
        UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activity_icon"] tag:0];
        [activityNavVC setTabBarItem:activityTab];
        
        [self setViewControllers:@[followingNavVC, activityNavVC]];
        
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
