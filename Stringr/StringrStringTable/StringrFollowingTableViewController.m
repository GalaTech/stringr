//
//  StringrFollowingTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 5/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFollowingTableViewController.h"
#import "StringrContainerScrollViewDelegate.h"

@interface StringrFollowingTableViewController ()

@end

@implementation StringrFollowingTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"Following";
    
    UIImageView *stringrImageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75 * (87/241))];
    stringrImageTitle.image = [UIImage imageNamed:@"stringr_logo"];
    
    self.navigationItem.titleView = stringrImageTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:1000];
    
    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"There are no strings from users you're following"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Discover People to Follow"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}


#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [StringrDiscoveryTabBarViewController new];
    
    //Need to implement a deep linking for explore buttons
}

@end
