//
//  StringrMyStringsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMyStringsTableViewController.h"
#import "StringrStringDetailViewController.h"

@interface StringrMyStringsTableViewController () <UIActionSheetDelegate>

@end

@implementation StringrMyStringsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    self.title = @"My Strings";
    
    //TODO: The action for this button is to edit a selected string. The selected string should be pushed in
    // with this method so that it can easil be transferred to the edit controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(pushToStringEdit)];
}




#pragma mark - Actions

// Handles the action of moving a user to edit the selected string.
// This will eventually incorporate the selection of a specific string and then taking the user
// to edit that string individually
- (void)pushToStringEdit
{
    StringrStringDetailViewController *stringEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
    
    [self.navigationController pushViewController:stringEditVC animated:YES];
}

@end
