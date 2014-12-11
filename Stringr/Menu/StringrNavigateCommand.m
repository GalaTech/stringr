//
//  StringrNavigateCommand.m
//  Stringr
//
//  Created by Jonathan Howard on 12/7/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateCommand.h"
#import "StringrFollowingTableViewController.h"
#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"


@interface StringrNavigateCommand ()

@end

@implementation StringrNavigateCommand

- (instancetype)initWithViewControllerClass:(Class)class delegate:(id)delegate
{
    self = [super init];
    
    if (self) {
        _viewControllerClass = class;
        _delegate = delegate;
    }
    
    return self;
}

- (void)execute
{
    if (self.segmentDisplayBlock) {
        self.segmentDisplayBlock(self.viewController);
    }
}


- (UIViewController *)viewController
{
    if (!_viewController) {
        _viewController = [self commandViewController];
    }
    
    return _viewController;
}


- (UIViewController *)commandViewController
{
    id viewController = [self.viewControllerClass new];
    
    if ([viewController isKindOfClass:[StringrFollowingTableViewController class]]) {
        StringrFollowingTableViewController *followingVC = (StringrFollowingTableViewController *)viewController;
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            followingVC.delegate = self.delegate;
        }
        
        return followingVC;
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
