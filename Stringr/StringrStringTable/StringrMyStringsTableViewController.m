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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pushToStringEdit)];
    
        
    //TODO: The action for this button is to edit a selected string. The selected string should be pushed in
    // with this method so that it can easily be transferred to the edit controller.
	self.navigationItem.rightBarButtonItem = editButton;
}




#pragma mark - Actions

// Handles the action of moving a user to edit the selected string.
// This will eventually incorporate the selection of a specific string and then taking the user
// to edit that string individually
- (void)pushToStringEdit
{
    
    StringrStringDetailViewController *stringEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    [stringEditVC setEditDetailsEnabled:YES];
    [stringEditVC setStringToLoad:self.objects[0]];
    
    [self.navigationController pushViewController:stringEditVC animated:YES];
     
    
    //[self.tableView setEditing:!self.tableView.editing animated:YES];
}




#pragma mark - UITableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a cell is selected it will push to that Strings edit page.
    StringrStringDetailViewController *stringEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    [stringEditVC setEditDetailsEnabled:YES];
    
    [self.navigationController pushViewController:stringEditVC animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"swiped");
    }
}

@end
