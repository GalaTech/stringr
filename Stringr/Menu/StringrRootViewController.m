//
//  StringrRootViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrRootViewController.h"

@interface StringrRootViewController ()

@end

@implementation StringrRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StringrMenuViewController"];
    
    self.liveBlur = YES;
}


@end
