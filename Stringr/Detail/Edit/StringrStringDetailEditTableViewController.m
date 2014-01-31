//
//  StringrStringDetailEditTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailEditTableViewController.h"
#import "StringrFooterView.h"

@interface StringrStringDetailEditTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSInteger selectedRow;

@property (weak, nonatomic) UITextView *stringDescriptionTextView;
@property (weak, nonatomic) UITextField *stringTagsTextField;
@property (weak, nonatomic) UIButton *addPhotoToStringButton;

@end

@implementation StringrStringDetailEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}




#pragma mark - Custom Accessors

- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Privacy", @"Delete"];
}



#pragma mark - Actions

// Provides initial functionality for adding a new photo to the current string
- (void)addPhotoToString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Photo to String" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    
    [newStringActionSheet showInView:self.view];
}




#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cellIdentifier = @"string_mainDetails";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 48) withFullWidthCell:YES];
                
                // Init's the footer with live data from here
                [mainDetailView.profileNameLabel setText:@"Alonso Holmes"];
                [mainDetailView.uploadDateLabel setText:@"10 minutes ago"];
                [mainDetailView.profileImageView setImage:[UIImage imageNamed:@"alonsoAvatar.jpg"]];
                [mainDetailView.commentsTextLabel setText:@"0"];
                [mainDetailView.likesTextLabel setText:@"0"];
                
                [cell addSubview:mainDetailView];
                
                //return footerCell;
            } else if (indexPath.row == 1) {
                cellIdentifier = @"string_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                self.addPhotoToStringButton = (UIButton *)[cell.contentView viewWithTag:5];
                [self.addPhotoToStringButton addTarget:self action:@selector(addPhotoToString) forControlEvents:UIControlEventTouchUpInside];
                
                //self.stringTitleTextField = (UITextField *)[cell.contentView viewWithTag:1];
                [self.stringTitleTextField setPlaceholder:self.stringTitle];
                
                //self.stringTitleTextField.delegate = self;
                
            } else if (indexPath.row == 2) {
                cellIdentifier = @"string_descriptionCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                //self.stringDescriptionTextView = (UITextView *)[cell.contentView viewWithTag:2];
                
                //self.stringDescriptionTextView.delegate = self;
            } else if (indexPath.row == 3) {
                cellIdentifier = @"string_tagsCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                //self.stringTagsTextField = (UITextField *)[cell.contentView viewWithTag:3];
                
                //self.stringTagsTextField.delegate = self;
            }
            break;
            
        case 1:
            if (indexPath.row == 0) {
                cellIdentifier = @"stringPrivacy_lockedCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (self.selectedRow == 0) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
            } else if (indexPath.row == 1) {
                cellIdentifier = @"stringPrivacy_mySchoolCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (self.selectedRow == 1) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
            } else if (indexPath.row == 2) {
                cellIdentifier = @"stringPrivacy_unlockedCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if (self.selectedRow == 2) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
            }
            break;
            
        case 2:
            if (indexPath.row == 0) {
                cellIdentifier = @"string_deleteCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            }
            break;
        default:
            break;
    }
    
    return cell;
}




#pragma mark - TableView Delegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 110;
    } else if (indexPath.section == 1) {
        return 55;
    }
    
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Stores previously selected (radio) row
    NSIndexPath *previousCellIndexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:1];
    
    switch (indexPath.section) {
        case 1:
            if (indexPath.row == 0) {
                self.selectedRow = 0;
            } else if (indexPath.row == 1) {
                self.selectedRow = 1;
            } else if (indexPath.row == 2) {
                self.selectedRow = 2;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                UIAlertView *deleteStringAlert = [[UIAlertView alloc] initWithTitle:@"Delete String" message:@"Are you sure that you want to delete this string? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
                
                [deleteStringAlert show];
            }
        default:
            break;
    }
    
    NSArray *indexPaths = @[indexPath, previousCellIndexPath];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}




#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@"Description..."]) {
        [textView setText:@""];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView text] length] == 0) {
        [textView setText:@"Description..."];
    }
}




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex]  isEqual:@"Yes"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
 #pragma mark - UITextField Delegate
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 [self.view endEditing:YES];
 return YES;
 }
 
 
 
 #pragma mark - UIScrollViewDelegate
 
 
 // Hides the keyboard if you begin to move the scroll view
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 [self.stringTitleTextField resignFirstResponder];
 [self.stringDescriptionTextView resignFirstResponder];
 [self.stringTagsTextField resignFirstResponder];
 }
 */




@end
