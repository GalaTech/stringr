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
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    
}

@end
