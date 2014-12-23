//
//  StringrNavigateProfileCommand.m
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateProfileCommand.h"
#import "StringrFollowingTableViewController.h"
#import "StringrProfileTableViewController.h"
#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"

@implementation StringrNavigateProfileCommand

- (UIViewController *)commandViewController
{
    id viewController = [self.viewControllerClass new];
    
    if ([viewController isKindOfClass:[StringrFollowingTableViewController class]]) {
        StringrFollowingTableViewController *followingVC = (StringrFollowingTableViewController *)viewController;
        
        return followingVC;
    }
    else if ([viewController isKindOfClass:[StringrProfileTableViewController class]]) {
        StringrProfileTableViewController *myStringsVC = (StringrProfileTableViewController *)viewController;
        myStringsVC.userForProfile = self.user;
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            myStringsVC.delegate = self.delegate;
        }
        
        return myStringsVC;
    }
    else if ([viewController isKindOfClass:[StringrPopularTableViewController class]]) {
        StringrPopularTableViewController *popularVC = (StringrPopularTableViewController *)viewController;
        
        return popularVC;
    }
    else if ([viewController isKindOfClass:[StringrDiscoveryTableViewController class]]) {
        StringrDiscoveryTableViewController *discoverVC = (StringrDiscoveryTableViewController *)viewController;
        
        return discoverVC;
    }
    
    return [UIViewController new];
}

@end
