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
        NSString *modifiedSearchText = [StringrUtility stringTrimmedForLeadingAndTrailingWhiteSpacesFromString:self.searchText];
        
        NSError *error = NULL;
        NSString *hashtagRegexPattern = @"(#[a-z]+)\\b";
        NSRange textRange = NSMakeRange(0, modifiedSearchText.length);
        
        NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:hashtagRegexPattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *hashtagMatches = [hashtagRegex matchesInString:modifiedSearchText options:NSMatchingReportProgress range:textRange];
        
        NSString *searchText = modifiedSearchText;
        if (hashtagMatches.count ==1) {
            for (NSTextCheckingResult *match in hashtagMatches) {
                searchText = [NSString stringWithFormat:@"(%@)\\b", [modifiedSearchText substringWithRange:match.range]];
            }
        }
        
        PFQuery *stringTitleQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [stringTitleQuery whereKey:kStringrStringTitleKey matchesRegex:searchText modifiers:@"i"];
        
        PFQuery *stringDescriptionQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [stringDescriptionQuery whereKey:kStringrStringDescriptionKey matchesRegex:searchText modifiers:@"i"];
        
        PFQuery *stringSearchQuery = [PFQuery orQueryWithSubqueries:@[stringTitleQuery, stringDescriptionQuery]];
        [stringSearchQuery orderByDescending:@"createdAt"];

        return stringSearchQuery;
    }
    
    PFQuery *nilQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [nilQuery whereKeyExists:@"nil"];
    
    return nilQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"Search for Strings or #hashtags"];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    }
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
