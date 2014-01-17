//
//  StringrUserSearchViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserSearchViewController.h"
#import "StringrUtility.h"

@interface StringrUserSearchViewController ()

@end

@implementation StringrUserSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"Find People";
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}



#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}




#pragma mark - UISearchBar Delegate

// Presents/Hides the scope bar and cancel button whenever the user goes to search
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

// Hides the keyboard whenever a user has canceled a search or has pressed the search button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


@end
