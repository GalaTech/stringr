//
//  StringrMySchoolViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMySchoolViewController.h"
#import "StringrUtility.h"

@interface StringrMySchoolViewController ()

@end

@implementation StringrMySchoolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"University Popular";
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
    
    self.tabBar.tintColor = [UIColor purpleColor];
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
