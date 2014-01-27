//
//  StringrTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrTabBarViewController.h"

@interface StringrTabBarViewController ()

@end

@implementation StringrTabBarViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"tab bar did appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"tab bar did disappear");
}


#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}




#pragma mark - UITabBar Delegate

// Sets the title for the navigation controller to be that of the tab bar item we are one
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    
}

@end
