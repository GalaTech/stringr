//
//  StringrStringDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringEditTableViewController.h"
#import "StringrFooterView.h"
#import "StringFooterTableViewCell.h"

@interface StringrStringEditTableViewController () <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSInteger selectedRow;

@property (weak, nonatomic) UITextView *stringDescriptionTextView;
@property (weak, nonatomic) UITextField *stringTagsTextField;

@property (weak, nonatomic) UIButton *addPhotoToStringButton;

@end

@implementation StringrStringEditTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    [self.tableView setScrollEnabled:NO];
    
    [self.tableView reloadData];
}




#pragma mark - Custom Accessors

/*
- (void)setStringTitle:(NSString *)stringTitle
{
    _stringTitle = stringTitle;
    
    [self.tableView reloadData];
}
 */




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
                
                //if (footerCell) {
                    //StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerCell.frame), 48)];
                    //[mainDetailView setIsFullWidthCell:YES];
                    
                    //[footerCell addSubview:mainDetailView];
                    //footerCell = [[StringFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
               // }
                
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
                //[self.stringTitleTextField setPlaceholder:self.stringTitle];
                
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
            [headerText setText:@"Privacy"];
            break;
        case 2:
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
    } else if (indexPath.section == 1) {
        return 55;
    }
    
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    [tableView reloadData];
}





#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"You have deleted the string");
    }
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





#pragma mark - Parallax ScrollView Delegate

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}

@end
