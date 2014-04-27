//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrNavigationController.h"

#import "StringrPhotoDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

#import "StringrMyStringsTableViewController.h"
#import "StringrUserTableViewController.h"

#import "StringTableViewCell.h"
#import "StringView.h"
#import "StringrFooterView.h"

#import "StringrStringDetailViewController.h"

#import "TestViewController.h"

@interface StringrStringTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StringViewDelegate, StringrFooterViewDelegate>

@end

@implementation StringrStringTableViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = kStringrStringClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 1;
    }
    
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Private

- (StringrFooterView *)addFooterViewToCellWithObject:(PFObject *)object
{
    static float const contentViewWidth = 320.0;
    static float const contentViewHeight = 41.5;
    static float const contentFooterViewWidthPercentage = .93;
    
    float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
    CGRect footerRect = CGRectMake(footerXLocation, 0, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
    StringrFooterView *footerView = [[StringrFooterView alloc] initWithFrame:footerRect fullWidthCell:NO withObject:object];
    [footerView setDelegate:self];
    
    return footerView;
}




#pragma mark - Action Handlers

// Handles the action of pushing to to the detail view of a selected string
- (void)pushToStringDetailView:(UIButton *)sender
{
    StringrStringDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
    
    PFObject *string = [self.objects objectAtIndex:sender.tag];
    
    if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [string objectForKey:kStringrStatisticsStringKey];
    } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [string objectForKey:kStringrActivityStringKey];
    }
    
    // tag is set to the section number of each string
    [detailVC setStringToLoad:string];
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}




#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One of the rows is for the footer view
    return 2;
}
 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}




#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //
    return 23.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

// Percentage for the width of the content header view
static float const contentViewWidthPercentage = .93;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Section header view, which is used for embedding the content view of the section header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView setAlpha:1];
    
    float xpoint = (headerView.frame.size.width - (headerView.frame.size.width * contentViewWidthPercentage)) / 2;
    CGRect contentHeaderRect = CGRectMake(xpoint, 0, headerView.frame.size.width * contentViewWidthPercentage, 23.5);
    
    
    // This is the content view, which is a button that will provide user interaction that can take them to
    // the detail view of a string
    UIButton *contentHeaderViewButton = [[UIButton alloc] initWithFrame:contentHeaderRect];
    [contentHeaderViewButton setBackgroundColor:[UIColor whiteColor]];
    [contentHeaderViewButton addTarget:self action:@selector(pushToStringDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [contentHeaderViewButton setAlpha:0.92];
    // Sets tag so we can easily access the correct string when a user taps the detail view for a string
    [contentHeaderViewButton setTag:section];
    
    PFObject *string = [self.objects objectAtIndex:section];
    
    if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [string objectForKey:kStringrStatisticsStringKey];
    } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [string objectForKey:kStringrActivityStringKey];
    }

    
    NSString *titleText = [string objectForKey:kStringrStringTitleKey];
    [contentHeaderViewButton setTitle:titleText forState:UIControlStateNormal];
    [contentHeaderViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [contentHeaderViewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [contentHeaderViewButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    
    [headerView addSubview:contentHeaderViewButton];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // string view
        return 157.0f;
    } else if (indexPath.row == 1) {
        // footer view
        return 52.0f;
    }
    
    return 0.0f;
}




#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable
{
    PFQuery *query = [self getQueryForTable];
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    
    return query;
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    PFObject *string = object;
    
    if ([object.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [object objectForKey:kStringrStatisticsStringKey];
    } else if ([object.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [object objectForKey:kStringrActivityStringKey];
    }
    
    //static NSString *cellIdentifier = @"Cell";
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"StringTableViewCell";
        StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!stringCell) {
            stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [stringCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [stringCell setStringViewDelegate:self];
        [stringCell setStringObject:string];

        return stringCell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"StringTableViewFooter";
        
        UITableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!footerCell) {
            footerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [footerCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        [footerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        StringrFooterView *footerView = [self addFooterViewToCellWithObject:string];
        
        [footerCell.contentView addSubview:footerView];
        
        return footerCell;
    } else {
        return nil;
    }
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
}

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    // returns the object for every collection string and footer cell
    if (indexPath.section < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.section];
    } else {
        return nil;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    PFTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
    [loadCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    return loadCell;
}




#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setStringOwner:string];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
        
    }
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

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object
{
    /*
    if (object) {
        if ([object.parseClassName isEqualToString:kStringrStringClassKey]) {
            [StringrUtility likeStringInBackground:object block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [footerView refreshLikesAndComments];
                }
            }];
        } else if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            [StringrUtility likePhotoInBackground:object block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [footerView refreshLikesAndComments];
                }
            }];
        }
    }
     */
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object
{
    if (object) {
        StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:object];
        
        NSString *forObjectKey = kStringrActivityStringKey;
        
        if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            forObjectKey = kStringrActivityPhotoKey;
        }
        
        PFQuery *query = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [query whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
        [query whereKey:forObjectKey equalTo:object];
        [query whereKeyExists:kStringrActivityFromUserKey];
        [query orderByDescending:@"createdAt"];
        [commentsVC setQueryForTable:query];
        
        [commentsVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}


@end
