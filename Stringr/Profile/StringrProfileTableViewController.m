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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];
}




#pragma mark - ParallaxScrollViewController Delegate

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}



#pragma mark - Old ParallaxController Delegate

/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 [self.parallaxController tableViewControllerDidScroll:self];
 }
 */



@end
