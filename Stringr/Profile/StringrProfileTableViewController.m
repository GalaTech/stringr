//
//  StringrProfileTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTableViewController.h"

@interface StringrProfileTableViewController ()

@end

@implementation StringrProfileTableViewController

#pragma mark - LifeCycle

- (void)dealloc
{
    NSLog(@"dealloc profile table");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setScrollEnabled:NO];
    // Enables scroll to top for the parallax view
    [self.tableView setScrollsToTop:NO];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    // Querries all strings that are owned by the user for the specified profile
    PFQuery *profileStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [profileStringsQuery whereKey:kStringrStringUserKey equalTo:self.userForProfile];
    [profileStringsQuery orderByDescending:@"createdAt"];
    
    return profileStringsQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"This user has no Strings"];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    }
}




#pragma mark - ParallaxScrollViewController Delegate

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}



@end
