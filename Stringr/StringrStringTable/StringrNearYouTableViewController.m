//
//  StringrNearYouTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 5/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNearYouTableViewController.h"

@interface StringrNearYouTableViewController ()

@end

@implementation StringrNearYouTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Near You";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *nearYouQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    if ([[PFUser currentUser] objectForKey:kStringrUserLocationKey]) {
        [nearYouQuery whereKey:kStringrStringLocationKey nearGeoPoint:[[PFUser currentUser] objectForKey:kStringrUserLocationKey] withinMiles:100.0];
    } else {
        [nearYouQuery whereKey:kStringrStringTitleKey equalTo:@"!@#%@#$^%^&*"];
    }
    [nearYouQuery orderByDescending:@"createdAt"];
    
    return nearYouQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:@"There are no Strings to Near You"];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    }
}

@end
