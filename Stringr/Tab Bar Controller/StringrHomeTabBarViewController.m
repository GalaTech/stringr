//
//  StringrHomeTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrNetworkRequests+Activity.h"

#import "StringrNavigationController.h"
#import "StringrFollowingTableViewController.h"

@implementation StringrHomeTabBarViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StringrFollowingTableViewController *followingVC = [[StringrFollowingTableViewController alloc] initWithStyle:UITableViewStylePlain];
        StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
        UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
        [followingNavVC setTabBarItem:followingTab];
        
        StringrActivityTableViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardActivityTableID];
        StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
        UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activity_icon"] tag:0];
        [activityNavVC setTabBarItem:activityTab];
        
        [self setViewControllers:@[followingNavVC, activityNavVC]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setTintColor:[StringrConstants kStringrBlueColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateActivityNotificationsTabValue];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"Activity"]) {
        item.badgeValue = nil;
    }
}

- (void)updateActivityNotificationsTabValue
{
    [StringrNetworkRequests numberOfActivitesForUser:[PFUser currentUser] completionBlock:^(NSInteger numberOfActivities, BOOL success) {
        if (success) {
            NSInteger numberOfPreviousActivities = [[[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsNumberOfActivitiesKey] integerValue];
            
            NSInteger numberOfNewActivities = numberOfActivities - numberOfPreviousActivities;
            
            if (numberOfNewActivities > 0) {
                UITabBarItem *activityTab = [[self.viewControllers lastObject] tabBarItem];
                [activityTab setBadgeValue:[NSString stringWithFormat:@"%d", numberOfNewActivities]];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@(numberOfActivities) forKey:kNSUserDefaultsNumberOfActivitiesKey];
        }
    }];
}


@end
