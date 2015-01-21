//
//  StringrDiscoveryTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDiscoveryTableViewController.h"

@interface StringrDiscoveryTableViewController ()

@end

@implementation StringrDiscoveryTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Discover";
    self.navigationItem.leftBarButtonItem = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PFQueryTableViewController Delegate

//- (PFQuery *)queryForTable
//{
//    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
//    [discoverQuery orderByDescending:@"updatedAt"];
//    
//    return discoverQuery;
//}
//
//- (void)objectsDidLoad:(NSError *)error
//{
//    [super objectsDidLoad:error];
//    
//    if (self.objects.count == 0) {
//        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"There are no Strings to Discover"];
//        [noContentHeaderView setTitleForExploreOptionButton:@"Why don't you add the first one?"];
//        [noContentHeaderView setDelegate:self];
//        
//        self.tableView.tableHeaderView = noContentHeaderView;
//    } else {
//        self.tableView.tableHeaderView = nil;
//    }
//}




#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
//    [self addNewString];
}

@end
