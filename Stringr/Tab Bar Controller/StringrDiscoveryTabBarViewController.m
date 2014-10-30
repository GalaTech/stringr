//
//  StringrStringDiscoveryTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrDiscoveryTabBarViewController.h"
#import "StringrLoginViewController.h"
#import "StringrNavigationController.h"
#import "StringrUtility.h"

#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"
#import "StringrNearYouTableViewController.h"
#import "UIColor+StringrColors.h"

@interface StringrDiscoveryTabBarViewController ()

@end

@implementation StringrDiscoveryTabBarViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        StringrPopularTableViewController *popularVC = [[StringrPopularTableViewController alloc] initWithStyle:UITableViewStylePlain];
        StringrNavigationController *popularNavVC = [[StringrNavigationController alloc] initWithRootViewController:popularVC];
        UITabBarItem *popularTab = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"crown_icon"] tag:0];
        [popularNavVC setTabBarItem:popularTab];
        
        StringrDiscoveryTableViewController *discoverVC = [[StringrDiscoveryTableViewController alloc] initWithStyle:UITableViewStylePlain];
        StringrNavigationController *discoverNavVC = [[StringrNavigationController alloc] initWithRootViewController:discoverVC];
        UITabBarItem *discoverTab = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
        [discoverNavVC setTabBarItem:discoverTab];
        
        StringrNearYouTableViewController *nearYouVC = [[StringrNearYouTableViewController alloc] initWithStyle:UITableViewStylePlain];
        StringrNavigationController *nearYouNavVC = [[StringrNavigationController alloc] initWithRootViewController:nearYouVC];
        UITabBarItem *nearYouTab = [[UITabBarItem alloc] initWithTitle:@"Near You" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
        [nearYouNavVC setTabBarItem:nearYouTab];
        
        [self setViewControllers:@[popularNavVC, discoverNavVC, nearYouNavVC]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // sets the title of the controller to the initial selected tab bar item
    self.title = @"Following";
    
    [self.tabBar setTintColor:[UIColor stringrLogoGreenColor]];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
    StringrNavigationController *navVC = self.viewControllers[0];
    UIViewController *visibleVC = navVC.topViewController;
    
    StringrLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [visibleVC presentViewController:loginVC animated:YES completion:nil];
     */
}





@end
