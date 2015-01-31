//
//  StringrUserStringFeedViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/31/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrUserStringFeedViewController.h"

@interface StringrUserStringFeedViewController ()

@end

@implementation StringrUserStringFeedViewController

#pragma mark - Lifecycle

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType user:(PFUser *)user
{
    StringrUserStringFeedViewController *userStringFeedVC = [StringrUserStringFeedViewController new];
    userStringFeedVC.user = user;
    userStringFeedVC.dataType = taskType;
    
    return userStringFeedVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


#pragma mark - Private

- (void)startStringNetworkTask
{
    [StringrNetworkTask stringsForDataType:self.dataType user:self.user completion:^(NSArray *strings, NSError *error) {
        self.strings = strings;
    }];
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

@end
