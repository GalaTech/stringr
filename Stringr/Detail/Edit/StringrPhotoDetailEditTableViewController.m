//
//  StringrPhotoDetailEditTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailEditTableViewController.h"
#import "StringrFooterView.h"

@interface StringrPhotoDetailEditTableViewController () <UIAlertViewDelegate>

@end

@implementation StringrPhotoDetailEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Custom Accessors

- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Delete"];
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
                [mainDetailView setupFooterViewWithObject:self.photoDetailsToLoad];
                [mainDetailView setDelegate:self];
                 
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 110.0f;
    }
    
    return 44.0f;
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
}




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex]  isEqual:@"Yes"]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterDeletePhotoFromStringKey object:@{@"image": @"image"}];
        }];
    }
}

@end
