//
//  StringrStringDiscoveryTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringDiscoveryTabBarViewController.h"
#import "StringrUtility.h"

@interface StringrStringDiscoveryTabBarViewController ()

@end

@implementation StringrStringDiscoveryTabBarViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // sets the title of the controller to the initial selected tab bar item
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