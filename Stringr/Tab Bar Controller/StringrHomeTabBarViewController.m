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

@implementation StringrHomeTabBarViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

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
