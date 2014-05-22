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
	
    self.title = @"Discovery";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [discoverQuery orderByDescending:@"updatedAt"];
    
    return discoverQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"There are no Strings to Discover"];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    }
}


@end
