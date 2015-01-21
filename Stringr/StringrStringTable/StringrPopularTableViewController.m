//
//  StringrPopularTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPopularTableViewController.h"

@interface StringrPopularTableViewController ()

@end

@implementation StringrPopularTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Popular";
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
//    PFQuery *popularQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
//    [popularQuery whereKeyExists:kStringrStatisticsStringKey];
//    [popularQuery includeKey:kStringrStatisticsStringKey];
//    [popularQuery orderByDescending:kStringrStatisticsCommentCountKey];
//    [popularQuery addDescendingOrder:kStringrStatisticsLikeCountKey];
//    [popularQuery setLimit:100];
//    
//    return popularQuery;
//}

//- (void)objectsDidLoad:(NSError *)error
//{
//    [super objectsDidLoad:error];
//    
//    if (self.objects.count == 0) {
//        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"There are no Popular Strings"];
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
