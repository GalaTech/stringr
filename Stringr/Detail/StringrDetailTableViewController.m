//
//  StringrDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTableViewController.h"
#import "StringrFooterView.h"

@interface StringrDetailTableViewController ()

@end

@implementation StringrDetailTableViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    [self.tableView setScrollEnabled:NO];
    
    // Hides the row separators on blank cells
    self.tableView.tableFooterView = [UIView new];
    
    //[self.tableView reloadData];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}




#pragma mark - TableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 50, 15)];
    
    // SectionHeaderTitles is pulled from photo/string subclasses getter
    switch (section) {
        case 0:
            [headerText setText:self.sectionHeaderTitles[0]];
            break;
        case 1:
            [headerText setText:self.sectionHeaderTitles[1]];
            break;
        case 2:
            [headerText setText:self.sectionHeaderTitles[2]];
            break;
        default:
            break;
    }
    
    [headerText setTextColor:[UIColor darkGrayColor]];
    [headerText setTextAlignment:NSTextAlignmentLeft];
    [headerText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    
    [headerView addSubview:headerText];
    
    return headerView;
}



#pragma mark - ParallaxView Delegate

-(UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}

@end
