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

@property (weak, nonatomic) IBOutlet UITextView *photoCaptionTextView;

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
                [self.photoCaptionTextView setText:[self.photoDetailsToLoad objectForKey:kStringrPhotoCaptionKey]];
                //[self.photoCaptionTextView setText:@"Amazing trip from around the world!"];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cellIdentifier = @"photo_stringOwnerCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            }
        default:
            break;
    }
    
    
    return cell;
}




#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 110;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 20;
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
