//
//  StringrProfileStringFeedViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/18/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrProfileStringFeedViewController.h"

@interface StringrProfileStringFeedViewController ()

@end

@implementation StringrProfileStringFeedViewController

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType user:(PFUser *)user
{
    StringrProfileStringFeedViewController *userStringFeedVC = [StringrProfileStringFeedViewController new];
    userStringFeedVC.modelController.userForFeed = user;
    userStringFeedVC.modelController.dataType = taskType;
    
    return userStringFeedVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 182.5f)];
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
}


- (void)dealloc
{
    NSLog(@"dealloc'd StringrProfileStringFeedViewController");
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - <StringrContainerScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.delegate containerViewDidScroll:scrollView];
    }
}


- (void)adjustScrollViewTopInset:(CGFloat)inset
{

}


- (UIScrollView *)containerScrollView
{
    return self.tableView;
}

@end
