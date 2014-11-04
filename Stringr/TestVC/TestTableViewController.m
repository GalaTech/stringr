//
//  TestTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewController.h"
#import "StringTableViewHeader.h"
#import "TestTableViewFooterActionCell.h"
#import "StringTableViewTitleCell.h"
#import "TestTableViewStringCell.h"

static NSString * const StringrStringTableViewController2 = @"StringTable";

@interface TestTableViewController ()

@end

@implementation TestTableViewController


+ (TestTableViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrStringTableViewController2 bundle:nil];
    return (TestTableViewController *)[storyboard instantiateInitialViewController];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.89f alpha:1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    self.tableView.backgroundColor = veryLightGrayColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"TestTableViewStringCell" bundle:nil] forCellReuseIdentifier:@"StringCell"];
        TestTableViewStringCell *stringCell = [tableView dequeueReusableCellWithIdentifier:@"StringCell" forIndexPath:indexPath];
        
        if (!stringCell) {
            stringCell = [TestTableViewStringCell new];
        }
        
        return stringCell;
    }
    else if (indexPath.row == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"TestTableViewFooterTitleCell" bundle:nil] forCellReuseIdentifier:@"StringFooterTitleCell"];
       StringTableViewTitleCell *footerCell = [tableView dequeueReusableCellWithIdentifier:@"StringFooterTitleCell" forIndexPath:indexPath];
        
        if (!footerCell) {
            footerCell = [StringTableViewTitleCell new];
        }
        
        return footerCell;
    }
    else if (indexPath.row == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"TestTableViewFooterActionCell" bundle:nil] forCellReuseIdentifier:@"StringFooterActionCell"];
        TestTableViewFooterActionCell *actionCell = [tableView dequeueReusableCellWithIdentifier:@"StringFooterActionCell" forIndexPath:indexPath];
        
        return actionCell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 270.0f;
    }
    else if (indexPath.row == 1) {
        return 47.0f;
    }
    else if (indexPath.row ==2) {
        return 55.0f;
    }
    
    return 0.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), [self tableView:tableView heightForHeaderInSection:section]);
    
    StringTableViewHeader *headerView = [[StringTableViewHeader alloc] initWithFrame:frame];
    
    return headerView;
}


@end
