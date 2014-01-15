//
//  StringrProfileTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTableViewController.h"
#import "M6ParallaxController.h"

@interface StringrProfileTableViewController ()

@end

@implementation StringrProfileTableViewController


#pragma mark - Parallax Controller Methods

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.parallaxController tableViewControllerDidScroll:self];
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];

}


- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}

@end
