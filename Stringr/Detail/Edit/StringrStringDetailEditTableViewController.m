//
//  StringrStringDetailEditTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailEditTableViewController.h"
#import "StringrWriteAndEditTextViewController.h"
#import "StringrNavigationController.h"
#import "StringrFooterView.h"

@interface StringrStringDetailEditTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StringrWriteAndEditTextViewControllerDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // initially sets the selected row based around the current ALC permissions of the string
    BOOL canWrite = [self.stringDetailsToLoad.ACL getPublicWriteAccess];
    if (canWrite) {
        self.selectedRow = 1; // public row
    } else {
        self.selectedRow = 0; // locked row
    }
    
    [self.delegate setStringWriteAccess:canWrite];
    
}


#pragma mark - Custom Accessors

- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Privacy", @"Delete"];
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
            return 3;
            break;
        case 1:
            return 2;
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
                
                StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 48) fullWidthCell:YES withObject:self.stringDetailsToLoad];
                [mainDetailView setDelegate:self];

                [cell addSubview:mainDetailView];
                
                //return footerCell;
            } else if (indexPath.row == 1) {
                cellIdentifier = @"string_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                StringrDetailTitleTableViewCell *titleTableVC = (StringrDetailTitleTableViewCell *)cell;
                [titleTableVC setTitleForCell:[self.stringDetailsToLoad objectForKey:kStringrStringTitleKey]];
                
            } else if (indexPath.row == 2) {
                cellIdentifier = @"string_descriptionCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                StringrDetailDescriptionTableViewCell *descriptionTableVC = (StringrDetailDescriptionTableViewCell *)cell;

                //NSDictionary *textAttributes = [descriptionTableVC getDescriptionTextAttributes];
                //NSString *descriptionText = [self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey];

                //CGSize sizeOfLabel = [descriptionText sizeWithAttributes:textAttributes];
                
                [descriptionTableVC setDescriptionForCell:[self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey]];
                
                
                
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
                cellIdentifier = @"stringPrivacy_unlockedCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if (self.selectedRow == 1) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // details/title/description
        StringrWriteAndEditTextViewController *editTextVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardWriteAndEditID];
        [editTextVC setDelegate:self];
        
        if (indexPath.row == 1) {
            [editTextVC setTextForEditing:[self.stringDetailsToLoad objectForKey:kStringrStringTitleKey]];
            [editTextVC setTitle:@"Edit Title"];
        } else if (indexPath.row == 2) {
            [editTextVC setTextForEditing:[self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey]];
            [editTextVC setTitle:@"Edit Description"];
        }
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:editTextVC];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    } else if (indexPath.section == 1) { // locked/public
        
        // Stores previously selected (radio) row
        NSIndexPath *previousCellIndexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:1];
        
        if (indexPath.row == 0) { // locked
            self.selectedRow = 0;
            
            [self.delegate setStringWriteAccess:NO];
        } else if (indexPath.row == 1) { // public
            self.selectedRow = 1;
            
            [self.delegate setStringWriteAccess:YES];
        }
        
        NSArray *indexPaths = @[indexPath];
        
        // If the two indexes are not the same I add them both to be reloaded.
        if (previousCellIndexPath.row != indexPath.row) {
            indexPaths = @[previousCellIndexPath, indexPaths[0]];
        }
        
        // If I attempted to load both the array without a conditional check it could crash if
        // the user happened to press the same row twice.
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    } else if (indexPath.section == 2) { // delete string
        if (indexPath.row == 0) {
            UIAlertView *deleteStringAlert = [[UIAlertView alloc] initWithTitle:@"Delete String" message:@"Are you sure that you want to delete this string? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            
            [deleteStringAlert show];
        }
    }
}




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex]  isEqual:@"Yes"]) {
        [self.delegate deleteString];
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark - StringrWriteAndEditTextView Delegate

- (void)reloadTextAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text
{
    if (indexPath.row == 1) {
        [self.stringDetailsToLoad setObject:text forKey:kStringrStringTitleKey];
    } else if (indexPath.row == 2) {
        [self.stringDetailsToLoad setObject:text forKey:kStringrStringDescriptionKey];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
