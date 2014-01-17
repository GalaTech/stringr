//
//  StringrUserConnectionsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserConnectionsTableViewController.h"

@interface StringrUserConnectionsTableViewController ()

@end

@implementation StringrUserConnectionsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Sets the title of the view based on what content it displays
    if ([self.view.restorationIdentifier isEqualToString:@"FollowingVC"]) {
        self.title = @"Following";
    } else if ([self.view.restorationIdentifier isEqualToString:@"FollowersVC"]) {
        self.title = @"Followers";
    }
    
}


@end
