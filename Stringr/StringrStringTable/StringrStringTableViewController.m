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
    
	
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adds observer's for different actions that can be performed by selecting different UIObject's on screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

- (StringrFooterView *)addFooterViewToCellWithObject:(PFObject *)object
{
    static float const contentViewWidth = 320.0;
    static float const contentViewHeight = 41.5;
    static float const contentFooterViewWidthPercentage = .93;
    
    float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
    CGRect footerRect = CGRectMake(footerXLocation, 0, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
    StringrFooterView *footerView = [[StringrFooterView alloc] initWithFrame:footerRect withFullWidthCell:NO];
    [footerView setupFooterViewWithObject:object];
    [footerView setDelegate:self];
    
    return footerView;
}




#pragma mark - NSNotificationCenter Oberserver Action Handlers

// Handles the action of pushing to to the detail view of a selected string
- (void)pushToStringDetailView:(UIButton *)sender
{
    StringrStringDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    
    [detailVC setStringToLoad:[self.objects objectAtIndex:sender.tag]];
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)addNewString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Create New String"
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
    
    [newStringActionSheet addButtonWithTitle:@"Take Photo"];
    [newStringActionSheet addButtonWithTitle:@"Choose from Existing"];
    
    /* Implement return to saved string
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if (![defaults objectForKey:kUserDefaultsWorkingStringSavedImagesKey]) {
        [newStringActionSheet addButtonWithTitle:@"Return to Saved String"];
        [newStringActionSheet setDestructiveButtonIndex:[newStringActionSheet numberOfButtons] - 1];
    }
     */
    
    [newStringActionSheet addButtonWithTitle:@"Cancel"];
    [newStringActionSheet setCancelButtonIndex:[newStringActionSheet numberOfButtons] - 1];
    
    
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [newStringActionSheet showInView:self.view];
    } else {
        [newStringActionSheet showInView:window];
    }
    
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
    return 23.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
    
    
    NSString *titleText = [[self.objects objectAtIndex:section] objectForKey:kStringrStringTitleKey];
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
        return 157;
    } else if (indexPath.row == 1) {
        // footer view
        return 52;
    }
    
    return 0;
}




#pragma mark - PFQueryTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    //static NSString *cellIdentifier = @"Cell";
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"StringTableViewCell";
        StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [stringCell setStringViewDelegate:self];
        [stringCell setStringObject:object];
        
        return stringCell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"StringTableViewFooter";
        
        UITableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [footerCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
        StringrFooterView *footerView = [self addFooterViewToCellWithObject:object];
        
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

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
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




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    } else if (buttonIndex == 0) {
        
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        
        
        UIImagePickerController *imagePickerController= [[UIImagePickerController alloc]init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        // image picker needs a delegate so we can respond to its messages
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 2) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
    
    
}




#pragma mark - UIImagePicker Delegate

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // TODO: Not sure why this is just a detail view and not edit 
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setEditDetailsEnabled:YES];
        [newStringVC setUserSelectedPhoto:image];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}




#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        /*
        TestViewController *testVC = [self.storyboard instantiateViewControllerWithIdentifier:@"testVC"];
        [testVC setPhotos:photos];
        [testVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:testVC animated:YES];
        */
        
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setStringOwner:string];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
        
    }
}


#pragma mark - StringrFooterView Delegate

- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader
{
    if (uploader) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        
        [profileVC setUserForProfile:uploader];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        [profileVC setHidesBottomBarWhenPushed:YES];

        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked String"
                                                    message:@"You have liked this String!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object
{
    StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringCommentsVC"];
    
    [commentsVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:commentsVC animated:YES];
}


@end
