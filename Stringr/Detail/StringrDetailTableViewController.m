//
//  StringrDetailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTableViewController.h"
#import "StringrNavigationController.h"
#import "StringrProfileViewController.h"
#import "StringrSearchTableViewController.h"
#import "UIColor+StringrColors.h"

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

    [self.tableView setBackgroundColor:[UIColor stringTableViewBackgroundColor]];
    
    [self.tableView setScrollEnabled:NO];
    
    // Hides the row separators on blank cells
    self.tableView.tableFooterView = [UIView new];
    
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
    [headerView setBackgroundColor:[UIColor stringrLightGrayColor]];
    
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



#pragma mark - StringrFooterView Delegate

- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader
{
    if (uploader) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        [profileVC setUserForProfile:uploader];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        
        [profileVC setHidesBottomBarWhenPushed:YES];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object inSection:(NSUInteger)section
{

}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object inSection:(NSUInteger)section
{
    if (object) {
        StringrCommentsTableViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:object];
        [commentsVC setDelegate:self];

        if (self.editDetailsEnabled) {
            [commentsVC setCommentsEditable:YES];
        }
        
        [commentsVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}



#pragma mark - StringrCommentsTableView Delegate

- (void)commentsTableView:(StringrCommentsTableViewController *)commentsTableView didChangeCommentCountInSection:(NSUInteger)section
{
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *footerCell = [self.tableView cellForRowAtIndexPath:footerIndexPath];
    
    // finds the footer view inside of the footer table view cell and updates the comments/like amount
    for (UIView *view in footerCell.contentView.subviews) {
        if ([view isKindOfClass:[StringrFooterView class]]) {
            StringrFooterView *footerView = (StringrFooterView *)view;
            [footerView refreshLikesAndComments];
        }
    }
}



#pragma mark - StringrDetailTableViewCell Delegate

- (void)tableViewCell:(StringrDetailTableViewCell *)cell tappedUserHandleWithName:(NSString *)name
{
    PFQuery *findUserQuery = [PFUser query];
    [findUserQuery whereKey:kStringrUserUsernameKey equalTo:name];
    [findUserQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (!error) {
            if (users.count > 0) {
                PFUser *user = [users firstObject];
                
                StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
                [profileVC setUserForProfile:user];
                [profileVC setProfileReturnState:ProfileModalReturnState];
                
                StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
                [self presentViewController:navVC animated:YES completion:nil];
            } else {
                NSLog(@"No user with that name was found!");
            }
        }
    }];
    
}

- (void)tableViewCell:(StringrDetailTableViewCell *)cell tappedHashtagWithText:(NSString *)text
{
    StringrSearchTableViewController *searchStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSearchStringsID];
    [searchStringsVC searchStringsWithText:text];
    
    searchStringsVC.navigationItem.leftBarButtonItem = nil;
    searchStringsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    [self.navigationController pushViewController:searchStringsVC animated:YES];
}


@end
