//
//  StringrStringSearchTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrSearchTableViewController.h"

@interface StringrSearchTableViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation StringrSearchTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Search Strings";
    
    if (self.searchText) {
        self.searchBar.text = self.searchText;
    }
}



#pragma mark - Public

- (void)searchStringsWithText:(NSString *)searchText
{
    self.searchText = searchText;
    [self loadObjects];
}



#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    if (self.searchText && [StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.searchText]) {
        
        PFQuery *stringTitleQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [stringTitleQuery whereKey:kStringrStringTitleKey containsString:self.searchText];
        
        PFQuery *stringDescriptionQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [stringDescriptionQuery whereKey:kStringrStringDescriptionKey containsString:self.searchText];
        
        PFQuery *stringSearchQuery = [PFQuery orQueryWithSubqueries:@[stringTitleQuery, stringDescriptionQuery]];
        
        return stringSearchQuery;
    }
    
    PFQuery *nilQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [nilQuery whereKeyExists:@"nil"];
    
    return nilQuery;
}




#pragma mark - UISearchBar Delegate

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
    self.searchText = searchBar.text;
    [self loadObjects];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
