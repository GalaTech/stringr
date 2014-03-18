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
    self.tableView = nil;
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




#pragma mark - ParallaxScrollViewController Delegate

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}



@end
