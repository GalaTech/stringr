//
//  StringrExploreViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrExploreViewController.h"
#import "StringrExploreTableViewCell.h"
#import "StringrExploreCategory.h"
#import "StringrNetworkTask+Explore.h"
#import "StringrNetworkTask+Search.h"

#import "StringrTableSection.h"

#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"
#import "StringrNearYouTableViewController.h"

#import "StringrProfileViewController.h"

#import "UIImage+StringrImageAdditions.h"
#import "NSString+StringrAdditions.h"

#import "StringrPhotoFeedViewController.h"

@interface StringrExploreViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categorySections;

@property (strong, nonatomic) NSMutableArray *filteredSearchResults;

@end

@implementation StringrExploreViewController

+ (StringrExploreViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StringrExploreStoryboard" bundle:nil];
    
    return (StringrExploreViewController *)[storyboard instantiateInitialViewController];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [StringrNetworkTask exploreCategorySections:^(NSArray *categories, NSError *error) {
            self.categorySections = categories;
            [self.tableView reloadData];
        }];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Explore";
    
    [self setupSearchDisplayAppearance];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchDisplayController.searchBar layoutSubviews];
}

- (void)setupSearchDisplayAppearance
{
    // Have to set translucent to NO or else there is a bug while using the UISearchBarStyleMinimal and a translucent nav bar
    self.navigationController.navigationBar.translucent = NO;
    self.searchDisplayController.searchBar.translucent = NO;
    
    // Fixes animation bug caused by having a non-translucent nav bar(translucent=NO due to another searchBar bug)
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ExploreCell"];
    
    self.searchDisplayController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchDisplayController.searchBar.tintColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.barTintColor = [UIColor whiteColor];
    
    self.searchDisplayController.searchBar.showsScopeBar = NO;
    
    self.searchDisplayController.searchBar.placeholder = @"Search Users and Tags";
    
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Avenir" size:14.0f]];
    
    [self.searchDisplayController.searchBar setScopeBarBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.searchDisplayController.searchBar setScopeBarButtonDividerImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    
    NSDictionary *segmentAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:13.0f], NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    NSDictionary *selectedSegmentAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:13.0f], NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    [self.searchDisplayController.searchBar setScopeBarButtonTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
    [self.searchDisplayController.searchBar setScopeBarButtonTitleTextAttributes:selectedSegmentAttributes forState:UIControlStateSelected];
    
    NSDictionary *cancelButtonAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:13.0f], NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitleTextAttributes:cancelButtonAttributes forState:UIControlStateNormal];
}


#pragma mark - Accessors



#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    return self.categorySections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredSearchResults.count;
    }
    
    StringrTableSection *tableSection = self.categorySections[section];
    
    return tableSection.sectionRows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StringrExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExploreCell"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
            PFUser *user = self.filteredSearchResults[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Search: %@, %@", user[kStringrUserUsernameKey], user[kStringrUserDisplayNameKey]];
        }
        else {
            PFObject *tag = self.filteredSearchResults[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"#%@", tag[@"Hashtag"]];
        }
    }
    else {
        StringrTableSection *tableSection = self.categorySections[indexPath.section];
        
        StringrExploreCategory *category = tableSection.sectionRows[indexPath.row];
        
        [cell configureForCategory:category];
    }
    
    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self selectedSearchRowAtIndexPath:indexPath];
        return;
    }
    
    StringrTableSection *tableSection = self.categorySections[indexPath.section];
    
    StringrExploreCategory *category = tableSection.sectionRows[indexPath.row];
    
    StringrStringFeedViewController *exploreStringVC = [StringrStringFeedViewController stringFeedWithCategory:category];
    exploreStringVC.navigationItem.title = category.name;
    [self.navigationController pushViewController:exploreStringVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)selectedSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.filteredSearchResults.count) return;
        
    if (self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
        PFUser *user = self.filteredSearchResults[indexPath.row];
        
        StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
        [profileVC setUserForProfile:user];
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    else {
        PFObject *tag = self.filteredSearchResults[indexPath.row];
        
        PFRelation *tagRelation = [tag relationForKey:@"Strings"];
        
        __weak typeof(self) weakSelf = self;
        PFQuery *tagQuery = [tagRelation query];
        [tagQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            StringrStringFeedViewController *taggedStringFeedVC = [StringrStringFeedViewController stringFeedWithStrings:objects];
            taggedStringFeedVC.navigationItem.title = [NSString stringWithHashtagFormat:[tag objectForKey:@"Hashtag"]];
            [weakSelf.navigationController pushViewController:taggedStringFeedVC animated:YES];
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return StringrExploreCellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.0f;
    
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor stringTableViewBackgroundColor];
    
    return headerView;
}


#pragma mark - Search Display Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.showsScopeBar = YES;
    self.searchDisplayController.searchBar.scopeButtonTitles = @[@"Users", @"Tags"];
    
    if (controller.searchBar.selectedScopeButtonIndex == 0) {
        controller.searchBar.placeholder = @"Search Users";
    }
    else {
        controller.searchBar.placeholder = @"Search Tags";
    }
}


- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.placeholder = @"Search Users and Tags";
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = controller.searchBar.text;
    self.filteredSearchResults = nil;
    
    if (searchOption == 0) {
        controller.searchBar.placeholder = @"Search Users";
        
        [StringrNetworkTask searchForUser:searchString completion:^(NSArray *users, NSError *error) {
            self.filteredSearchResults = [users copy];
            [controller.searchResultsTableView reloadData];
        }];
    }
    else {
        controller.searchBar.placeholder = @"Search Tags";
        
        [StringrNetworkTask searchForTag:searchString completion:^(NSArray *tags, NSError *error) {
            self.filteredSearchResults = [tags mutableCopy];
            [controller.searchResultsTableView reloadData];
        }];
    }
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (controller.searchBar.selectedScopeButtonIndex == 0) {
        [StringrNetworkTask searchForUser:searchString completion:^(NSArray *users, NSError *error) {
            self.filteredSearchResults = [users copy];
            [controller.searchResultsTableView reloadData];
        }];
    }
    else {
        [StringrNetworkTask searchForTag:searchString completion:^(NSArray *tags, NSError *error) {
            self.filteredSearchResults = [tags copy];
            [controller.searchResultsTableView reloadData];
        }];
    }
    
    return YES;
}

@end