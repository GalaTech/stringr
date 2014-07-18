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

@interface StringrStringDetailTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSInteger selectedRow;

@property (weak, nonatomic) UITextView *stringDescriptionTextView;
@property (weak, nonatomic) UITextField *stringTagsTextField;
@property (weak, nonatomic) UIButton *addPhotoToStringButton;

@end

@implementation StringrStringDetailTableViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.stringDetailsToLoad) {
        self.stringTitle = [self.stringDetailsToLoad objectForKey:kStringrStringTitleKey];
        self.stringDescription = [self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey];
    } else {
        self.stringTitle = @"Enter the title for your String";
        self.stringDescription = @"Enter the description for your String";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    NSLog(@"dealloc string detail table");
}



//*********************************************************************************/
#pragma mark - Custom Accessors
//*********************************************************************************/
 
- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Privacy"];
}



//*********************************************************************************/
#pragma mark - Action Handlers
//*********************************************************************************/

- (void)refreshStringDetails
{
    NSIndexPath *stringDetailsIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *stringDetailsCell = [self.tableView cellForRowAtIndexPath:stringDetailsIndexPath];
    
    for (UIView *detailsCellSubview in stringDetailsCell.contentView.subviews) {
        if ([detailsCellSubview isKindOfClass:[StringrFooterView class]]) {
            StringrFooterView *stringDetailView = (StringrFooterView *)detailsCellSubview;
            [stringDetailView refreshLikesAndComments];
        }
    }
}



//*********************************************************************************/
#pragma mark - TableView Data Source
//*********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
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
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 48) fullWidthCell:YES withObject:self.stringDetailsToLoad];
                [mainDetailView setDelegate:self];
                 
                [cell.contentView addSubview:mainDetailView];
            } else if (indexPath.row == 1) {
                cellIdentifier = @"string_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailTitleTableViewCell class]]) {
                    StringrDetailTitleTableViewCell *titleCell = (StringrDetailTitleTableViewCell *)cell;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [titleCell setTitleForCell:self.stringTitle];
                    });
                    
                    [titleCell setDelegate:self];
                    
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
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [descriptionCell setDescriptionForCell:self.stringDescription];
                    });
                    
                    NSString *test = [descriptionCell getDescriptionText];
                    NSLog(@"%@", [descriptionCell getDescriptionText]);
                    
                    [descriptionCell setDelegate:self];
                    
                    return descriptionCell;
                }
                //self.stringDescriptionTextView = (UITextView *)[cell.contentView viewWithTag:2];
                
                //self.stringDescriptionTextView.delegate = self;
            }
            /*
            else if (indexPath.row == 3) {
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
             */
             
            break;
            
        case 1:
            if (indexPath.row == 0) {
                
                if ([self.stringDetailsToLoad.ACL getPublicWriteAccess]) {
                    cellIdentifier = @"stringPrivacy_unlockedCell";
                } else {
                    cellIdentifier = @"stringPrivacy_lockedCell";
                }
                
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                /*
                if (self.selectedRow == 0) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
                 */
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



//*********************************************************************************/
#pragma mark - TableView Delegate
//*********************************************************************************/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //NSString *titleText = [self.stringDetailsToLoad objectForKey:kStringrStringTitleKey];
            
            if (!self.stringDetailsToLoad) {
                //titleText = @"";
            }

            return [StringrUtility heightForLabelWithNSString:self.stringTitle]; // the 31 is for additional margin space
        } else if (indexPath.row == 2) {
            //NSString *descriptionText = [self.stringDetailsToLoad objectForKey:kStringrStringDescriptionKey];
            
            if (!self.stringDetailsToLoad) {
               // descriptionText = @"";
            }

            return [StringrUtility heightForLabelWithNSString:self.stringDescription]; // the 31 is for additional margin space
        }
    } else if (indexPath.section == 1) {
        return 55.0f;
    }
    
    return 44.0f;
}






@end
