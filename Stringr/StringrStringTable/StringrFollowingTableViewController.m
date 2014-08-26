//
//  StringrFollowingTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 5/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFollowingTableViewController.h"

@interface StringrFollowingTableViewController ()

@end

@implementation StringrFollowingTableViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Following";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//*********************************************************************************/
#pragma mark - PFQueryTableViewController Delegate
//*********************************************************************************/

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
        
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"There are no strings from users you're following"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Discover People to Follow"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}


//*********************************************************************************/
#pragma mark - StringrNoContentView Delegate
//*********************************************************************************/

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupDiscoveryTabBarController];
    
    [self.frostedViewController setContentViewController:discoveryTabBarVC];
}

@end
