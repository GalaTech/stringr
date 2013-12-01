//
//  StringrStringSearchTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringSearchTableViewController.h"

@interface StringrStringSearchTableViewController () <UISearchBarDelegate>

@end

@implementation StringrStringSearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


// Presents/Hides the scope bar and cancel button whenever the user goes to search
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

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
