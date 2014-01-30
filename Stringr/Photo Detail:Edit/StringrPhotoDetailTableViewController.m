//
//  StringrPhotoDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTableViewController.h"
#import "StringrFooterView.h"

@interface StringrPhotoDetailTableViewController ()

@end

@implementation StringrPhotoDetailTableViewController

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
    
    [self.tableView reloadData];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cellIdentifier = @"photo_mainDetails";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 48) withFullWidthCell:YES];
                
                // Init's the footer with live data from here
                [mainDetailView.profileNameLabel setText:@"Alonso Holmes"];
                [mainDetailView.uploadDateLabel setText:@"10 minutes ago"];
                [mainDetailView.profileImageView setImage:[UIImage imageNamed:@"alonsoAvatar.jpg"]];
                [mainDetailView.commentsTextLabel setText:@"0"];
                [mainDetailView.likesTextLabel setText:@"0"];
                
                [cell addSubview:mainDetailView];
            } else if (indexPath.row == 1) {
                cellIdentifier = @"photo_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            } else if (indexPath.row == 2) {
                cellIdentifier = @"photo_descriptionCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cellIdentifier = @"photo_deleteCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            }
            break;
        default:
            break;
    }
    
    
    return cell;
}



#pragma mark - TableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 50, 15)];
    
    switch (section) {
        case 0:
            [headerText setText:@"Info"];
            break;
        case 1:
            [headerText setText:@"Delete"];
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

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 110;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            if (indexPath.row == 0) {
                UIAlertView *deletePhotoAlert = [[UIAlertView alloc] initWithTitle:@"Delete Photo" message:@"Are you sure that you want to delete this photo? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
                
                [deletePhotoAlert show];
            }
        default:
            break;
    }
    
    [tableView reloadData];
}


#pragma mark - ParallaxView Delegate

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}

@end
