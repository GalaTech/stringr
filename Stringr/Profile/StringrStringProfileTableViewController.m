//
//  StringrStringProfileTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringProfileTableViewController.h"
#import "StringrContainerScrollViewDelegate.h"

@implementation StringrStringProfileTableViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate containerViewDidScroll:scrollView];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [self.delegate containerViewShouldScrollToTop:scrollView];
}

@end
