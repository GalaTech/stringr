//
//  StringrPhotoDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTableViewController.h"
#import "StringrStringDetailViewController.h"
#import "StringrFooterView.h"

@interface StringrPhotoDetailTableViewController ()

@end

@implementation StringrPhotoDetailTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}




#pragma mark - Custom Accessors

- (NSArray *)sectionHeaderTitles
{
    return @[@"Info", @"Owner"];
}




#pragma mark - Public

- (void)reloadPhotoDetailsWithScrollDirection:(ScrollDirection)direction
{
    UITableViewRowAnimation rowAnimation;
    
    if (direction == ScrolledLeft) {
        rowAnimation = UITableViewRowAnimationLeft;
    } else {
        rowAnimation = UITableViewRowAnimationRight;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:0];
    //NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath, indexPath2, indexPath3] withRowAnimation:rowAnimation];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    /*
    else if (section == 1) {
        return 1;
    } 
     */
     else {
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
                
                StringrFooterView *mainDetailView = [[StringrFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 48) fullWidthCell:YES withObject:self.photoDetailsToLoad];
                [mainDetailView setDelegate:self];
                 
                [cell addSubview:mainDetailView];
            } else if (indexPath.row == 1) {
                cellIdentifier = @"photo_titleCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailTitleTableViewCell class]]) {
                    StringrDetailTitleTableViewCell *titleCell = (StringrDetailTitleTableViewCell *)cell;
                    
                    NSString *photoTitle = [self.photoDetailsToLoad objectForKey:kStringrPhotoCaptionKey];
                    [titleCell setTitleForCell:photoTitle];
                    
                    return titleCell;
                }
            } else if (indexPath.row == 2) {
                cellIdentifier = @"photo_descriptionCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                if ([cell isKindOfClass:[StringrDetailDescriptionTableViewCell class]]) {
                    StringrDetailDescriptionTableViewCell *descriptionCell = (StringrDetailDescriptionTableViewCell *)cell;
                    [descriptionCell setDescriptionForCell:[self.photoDetailsToLoad objectForKey:kStringrPhotoDescriptionKey]];
                    
                    return descriptionCell;
                }
            }
            break;
            
            /*
        case 1:
            if (indexPath.row == 0) {
                cellIdentifier = @"photo_stringOwnerCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if ([cell isKindOfClass:[StringrDetailPhotoOwnerTableViewCell class]]) {
                    StringrDetailPhotoOwnerTableViewCell *photoOwnerCell = (StringrDetailPhotoOwnerTableViewCell *)cell;
                    
                    NSString *stringOwnerTitle = [self.stringOwner objectForKey:kStringrStringTitleKey];
                    [photoOwnerCell setStringOwnerNameForCell:stringOwnerTitle];
                    
                    return photoOwnerCell;
                }

            }
             
             */
        default:
            break;
    }
    
    
    return cell;
}




#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSString *titleText = [self.photoDetailsToLoad objectForKey:kStringrPhotoCaptionKey];

            return [StringrUtility heightForLabelWithNSString:titleText]; // the 31 is for additional margin space
        } else if (indexPath.row == 2) {
            NSString *descriptionText = [self.photoDetailsToLoad objectForKey:kStringrPhotoDescriptionKey];
            
            return  [StringrUtility heightForLabelWithNSString:descriptionText]; // the 31 is for additional margin space
        }
    }
    
    /*else if (indexPath.section == 1) {
        return 55.0f;
    }
     */
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            if (indexPath.row == 0) {
                StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
                [stringDetailVC setStringToLoad:self.stringOwner];
                [self.navigationController pushViewController:stringDetailVC animated:YES];
            }
            break;
            
        default:
            break;
    }
}







@end
