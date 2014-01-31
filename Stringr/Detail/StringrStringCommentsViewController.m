//
//  StringrStringCommentsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringCommentsViewController.h"
#import "StringrPathImageView.h"

@interface StringrStringCommentsViewController ()

@end

@implementation StringrStringCommentsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"String Comments";
    
    [self.tableView setScrollsToTop:YES];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeComment)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions

- (void)writeComment
{
    
}



#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //[self.commentProfileImage setImageToCirclePath];
    
    // Creates the path and image for a profile thumbnail
    StringrPathImageView *cellProfileImage = (StringrPathImageView *)[self.view viewWithTag:1];
    [cellProfileImage setImageToCirclePath];
    [cellProfileImage setPathColor:[UIColor darkGrayColor]];
    [cellProfileImage setPathWidth:1.0];
    
    
    return cell;
}

#pragma mark - TableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UIImageView *topContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1)];
    [topContourLine setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
    
    UIImageView *bottomContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, CGRectGetWidth(self.view.frame), 1)];
    [bottomContourLine setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
    
    [headerView addSubview:topContourLine];
    //[headerView addSubview:bottomContourLine];
    
    
    return headerView;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

@end
