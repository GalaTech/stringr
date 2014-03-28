//
//  StringrRootViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrRootViewController.h"
#import "StringrLoginViewController.h"
#import "StringrNavigationController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrStringTableViewController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"

@interface StringrRootViewController ()

@end

@implementation StringrRootViewController

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    UIViewController *testVC = [[UIViewController alloc] init];
    [testVC.view setBackgroundColor:[UIColor whiteColor]];
    
    self.contentViewController = testVC;
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StringrMenuViewController"];
    
    self.liveBlur = YES;
    // makes the menu thinner than the default
    self.menuViewSize = CGSizeMake(250, CGRectGetHeight(self.view.frame));
    
    // Sets the navigation bar title to a lighter font variant throughout the app.
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f]
                                                            }];
}

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController
{
    self = [super init];
    
    if (self) {
        self.contentViewController = contentViewController;
        self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StringrMenuViewController"];
        
        self.liveBlur = YES;
        // makes the menu thinner than the default
        self.menuViewSize = CGSizeMake(250, CGRectGetHeight(self.view.frame));
        
        // Sets the navigation bar title to a lighter font variant throughout the app.
        [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                                NSForegroundColorAttributeName: [UIColor grayColor],
                                                                NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f]
                                                                }];
    }
    
    return self;
}

- (StringrHomeTabBarViewController *)setupHomeTabBarController
{
    StringrHomeTabBarViewController *homeTabBarVC = [[StringrHomeTabBarViewController alloc] init];
    
    StringrStringTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [followingVC setTitle:@"Following"];
    
    /*
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:1000];
    
    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByAscending:@"createdAt"];
    
    [followingVC setQueryForTable:query];
    */
     
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    
    StringrActivityTableViewController *activityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"activityVC"];
    [activityVC setTitle:@"Activity"];
    
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    
    [homeTabBarVC setViewControllers:@[followingNavVC, activityNavVC]];
    
    return homeTabBarVC;
}

- (StringrDiscoveryTabBarViewController *)setupDiscoveryTabBarController
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [[StringrDiscoveryTabBarViewController alloc] init];
    
    StringrStringTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [followingVC setTitle:@"Following"];
    
    PFQuery *followingQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [followingQuery orderByAscending:@"createdAt"];
    [followingVC setQueryForTable:followingQuery];
    
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    
    StringrStringTableViewController *popularVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [popularVC setTitle:@"Popular"];
    
    PFQuery *popularQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [popularQuery orderByDescending:@"createdAt"];
    [popularVC setQueryForTable:popularQuery];
    
    StringrNavigationController *popularNavVC = [[StringrNavigationController alloc] initWithRootViewController:popularVC];
    UITabBarItem *popularTab = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"crown_icon"] tag:0];
    [popularNavVC setTabBarItem:popularTab];
    
    
    StringrStringTableViewController *discoverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [discoverVC setTitle:@"Discover"];
    
    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [discoverQuery orderByAscending:@"createdAt"];
    [discoverVC setQueryForTable:discoverQuery];
    
    StringrNavigationController *discoverNavVC = [[StringrNavigationController alloc] initWithRootViewController:discoverVC];
    UITabBarItem *discoverTab = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [discoverNavVC setTabBarItem:discoverTab];
    
    
    StringrStringTableViewController *nearYouVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [nearYouVC setTitle:@"Near You"];
    
    PFQuery *nearYouQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [nearYouQuery orderByDescending:@"createdAt"];
    [nearYouVC setQueryForTable:nearYouQuery];
    
    StringrNavigationController *nearYouNavVC = [[StringrNavigationController alloc] initWithRootViewController:nearYouVC];

    UITabBarItem *nearYouTab = [[UITabBarItem alloc] initWithTitle:@"Near You" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
    [nearYouNavVC setTabBarItem:nearYouTab];
    
    [discoveryTabBarVC setViewControllers:@[followingNavVC, popularNavVC, discoverNavVC, nearYouNavVC]];
    
    
    return discoveryTabBarVC;
}

@end
