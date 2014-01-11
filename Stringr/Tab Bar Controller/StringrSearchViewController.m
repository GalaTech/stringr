//
//  StringrSearchViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrSearchViewController.h"
#import "StringrUtility.h"

@interface StringrSearchViewController ()

@end

@implementation StringrSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Search Strings";

    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
    
    
    self.tabBar.tintColor = [UIColor redColor];
}

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

// Sets the title for the navigation controller to be that of the tab bar item we are one
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    
}

@end
