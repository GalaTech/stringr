//
//  StringrUserSearchViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserSearchViewController.h"
#import "StringrUtility.h"
#import "UIColor+StringrColors.h"

#import "StringrNetworkTask+Search.h"

@interface StringrUserSearchViewController ()

@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

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
    
    self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
}



#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}



#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    if (self.searchText && [StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.searchText]) {

        NSString *modifiedSearchText = [StringrUtility stringTrimmedForLeadingAndTrailingWhiteSpacesFromString:self.searchText];
        
        //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(username BEGINSWITH[c]%@) OR (displayNameCaseInsensitive BEGINSWITH[c]%@)", lowercaseSearchText, lowercaseSearchText];
        //PFQuery * userQuery = [PFQuery queryWithClassName:@"_User" predicate:predicate];
        
        // Forces search to look at the beginning pattern of words so that it's not matching letters in the center
        // of a word. Also looks at the end of word to match for last names.
        //NSString *usernameSearchRegexPattern = [NSString stringWithFormat:@"^%@|%@$", modifiedSearchText, modifiedSearchText];
        
        // I check for username case sensitive on both just to make sure the user is completed in sign-up. This will be corrected.
        PFQuery *userUsernameQuery = [PFUser query];
        [userUsernameQuery whereKey:kStringrUserUsernameKey matchesRegex:modifiedSearchText modifiers:@"i"];
        [userUsernameQuery whereKeyExists:kStringrUserUsernameCaseSensitive];
        
        PFQuery *userDisplaynameQuery = [PFUser query];
        [userDisplaynameQuery whereKey:kStringrUserDisplayNameKey matchesRegex:modifiedSearchText modifiers:@"i"];
        [userDisplaynameQuery whereKeyExists:kStringrUserUsernameCaseSensitive];
        
        PFQuery *userQuery = [PFQuery orQueryWithSubqueries:@[userUsernameQuery, userDisplaynameQuery]];
        [userQuery orderByAscending:kStringrUserUsernameKey];
        
        return userQuery;
    }
    
    PFQuery *nilQuery = [PFUser query];
    [nilQuery whereKeyExists:@"nil"];
    
    return nilQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        //StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"Search for a user by their Username or Display Name"];
        
        //self.tableView.tableHeaderView = noContentHeaderView;
    }
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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
