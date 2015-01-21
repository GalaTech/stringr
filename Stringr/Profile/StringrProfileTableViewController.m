//
//  StringrProfileTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTableViewController.h"
#import "UIColor+StringrColors.h"

@interface StringrProfileTableViewController ()

@end

@implementation StringrProfileTableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor stringTableViewBackgroundColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Stringr Container ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    [self.delegate containerViewDidScroll:scrollView];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [self.delegate containerViewShouldScrollToTop:scrollView];
}


- (void)adjustScrollViewTopInset:(CGFloat)inset
{
    UIEdgeInsets newInsets = self.tableView.contentInset;
    newInsets.top = inset;
    self.tableView.contentInset = newInsets;
}


- (UIScrollView *)containerScrollView
{
    return self.tableView;
}


#pragma mark - PFQueryTableViewController Delegate

//- (PFQuery *)queryForTable
//{
//    // Querries all strings that are owned by the user for the specified profile
//    PFQuery *profileStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
//    [profileStringsQuery whereKey:kStringrStringUserKey equalTo:self.userForProfile];
//    [profileStringsQuery orderByDescending:@"createdAt"];
//    
//    return profileStringsQuery;
//}
//
//- (void)objectsDidLoad:(NSError *)error
//{
//    [super objectsDidLoad:error];
//    
//    if (self.objects.count == 0) {
//        NSString *username = [self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive];
//        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:[NSString stringWithFormat:@"@%@ hasn't uploaded any Strings!", username]];
//        self.tableView.tableHeaderView = noContentHeaderView;
//    }
//}

@end
