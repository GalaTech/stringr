//
//  StringrFollowingFollowersTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrFollowingFollowersTabBarViewController.h"
#import "StringrUtility.h"

@interface StringrFollowingFollowersTabBarViewController ()

@end

@implementation StringrFollowingFollowersTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Following";
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered target:self
                                                                            action:@selector(showMenu)];
}

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    
}

@end
