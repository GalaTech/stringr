//
//  StringrStringDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTableViewController.h"
#import "StringrFooterView.h"
#import "StringrDetailTagsTableViewCell.h"

@interface StringrStringDetailTableViewController () <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSInteger selectedRow;

@property (weak, nonatomic) UITextView *stringDescriptionTextView;
@property (weak, nonatomic) UITextField *stringTagsTextField;
@property (weak, nonatomic) UIButton *addPhotoToStringButton;


@end

@implementation StringrStringDetailTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}




#pragma mark - Custom Accessors

- (void)setStringTitle:(NSString *)stringTitle
{
    _stringTitle = stringTitle;
    
    NSIndexPath *titleIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[titleIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}
 
- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Privacy"];
}




#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
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
                [mainDetailView setupFooterViewWithObject:self.stringDetailsToLoad];
                [mainDetailView setDelegate:self];
                 
                [cell addSubview:mainDetailView];
                
                //return footerCell;
            } else if (indexPath.row == 1) {
                cellIdentifier = @"string_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailTitleTableViewCell class]]) {
                    StringrDetailTitleTableViewCell *titleCell = (StringrDetailTitleTableViewCell *)cell;
                    NSString *stringTitle = [self.stringDetailsToLoad objectForKey:kStringrStringTitleKey];
                    [titleCell setTitleForCell:stringTitle];
                    
                    return titleCell;
                }
                
                //self.stringTitleTextField = (UITextField *)[cell.contentView viewWithTag:1];
                //[self.stringTitleTextField setPlaceholder:self.stringTitle];
                
                //self.stringTitleTextField.delegate = self;
                
            } else if (indexPath.row == 2) {
                cellIdentifier = @"string_descriptionCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailDescriptionTableViewCell class]]) {
                    StringrDetailDescriptionTableViewCell *descriptionCell = (StringrDetailDescriptionTableViewCell *)cell;
                    NSString *stringDescription = [self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey];
                    [descriptionCell setDescriptionForCell:stringDescription];
                    
                    return descriptionCell;
                }
                //self.stringDescriptionTextView = (UITextView *)[cell.contentView viewWithTag:2];
                
                //self.stringDescriptionTextView.delegate = self;
            } else if (indexPath.row == 3) {
                cellIdentifier = @"string_tagsCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailTagsTableViewCell class]]) {
                    StringrDetailTagsTableViewCell *tagsCell = (StringrDetailTagsTableViewCell *)cell;
                    [tagsCell setTagsForCell:@"vacation, photography, wildlife, coast2Coast"];
                    
                    return tagsCell;
                }
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
            }
            /*
            else if (indexPath.row == 1) {
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
             */
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
    } else if (indexPath.section == 1) {
        return 55.0f;
    }
    
    
    return 44.0f;
}





@end