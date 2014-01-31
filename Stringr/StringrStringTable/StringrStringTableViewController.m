//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrNavigationController.h"

#import "StringrTempDetailViewController.h"
#import "StringrPhotoViewerViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

#import "StringrMyStringsTableViewController.h"
#import "StringrUserTableViewController.h"

#import "StringTableViewCell.h"
#import "StringFooterTableViewCell.h"

#import "StringrStringDetailViewController.h"

@interface StringrStringTableViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *images2;

@end

@implementation StringrStringTableViewController

#pragma mark - Lifecycle

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
    
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    
    
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adds observer's for different actions that can be performed by selecting different UIObject's on screen
    NSLog(@"Added observers from viewWillAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfileImage:) name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCommentsButton:) name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectLikesButton:) name:@"didSelectLikesButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:@"UploadNewString" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"Removed observers from view disappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
}




#pragma mark - Custom Accessors

static int const NUMBER_OF_IMAGES = 24;

// Getter for test data images property
- (NSArray *)images
{
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
        NSString *imageName = [NSString stringWithFormat:@"photo-%02d.jpg", i];
        
        NSDictionary *photo = @{@"title": @"Article A1", @"image": imageName};
        
        [images addObject:photo];
    }
    _images = [images copy];
    
    return _images;
}

- (NSArray *)images2
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 24; i >= 1; i--) {
        NSString *imageName = [NSString stringWithFormat:@"photo-%02d.jpg", i];
        
        NSDictionary *photo = @{@"title": @"Article A1", @"image": imageName};
        
        [images addObject:photo];
    }
    _images2 = [images copy];
    
    return _images2;
}



#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}




#pragma mark - NSNotificationCenter Oberserver Action Handlers

// Handles the action when a cell from a string is selected this will push to the appropriate VC
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    
    if (cellData)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
        
        [photoDetailVC setDetailsEditable:NO];
        // Sets the initial photo to the selected cell
        [photoDetailVC setCurrentImage:[UIImage imageNamed:[cellData objectForKey:@"image"]]];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}

// Handles the action of pushing to a selected user's profile
- (void)didSelectProfileImage:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
    NSLog(@"Removed observers from selecting profile");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
    
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    [profileVC setCanGoBack:YES];
    [profileVC setCanEditProfile:NO];
    [profileVC setTitle:@"User Profile"];
    //[profileVC setCanCloseModal:YES];
    
    [profileVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:profileVC animated:YES];
    
    //Implements modal transition to profile view
    //StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    //[self presentViewController:navVC animated:YES completion:nil];
}

// Handles the action of pushing to the comment's of a selected string
- (void)didSelectCommentsButton:(NSNotification *)notification
{
    StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringCommentsVC"];
    
    [self.navigationController pushViewController:commentsVC animated:YES];
}

// Handles the action of liking the selected string
- (void)didSelectLikesButton:(NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked String"
                                                    message:@"You have liked this String!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

// Handles the action of pushing to to the detail view of a selected string
- (void)pushToStringDetailView
{
    StringrDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
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
    // This will be set to the amount of strings that are loaded from parse
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One of the rows is for the footer view
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"StringTableViewCell";
        StringTableViewCell *stringCell = (StringTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!stringCell) {
            stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.section % 2 == 0) {
            [stringCell setCollectionData:self.images];
        } else {
            [stringCell setCollectionData:self.images2];
        }
        
        return stringCell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"StringTableViewFooter";
        StringFooterTableViewCell *footerCell = (StringFooterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (footerCell) {
            footerCell = [[StringFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // Init's the footer with live data from here
        [footerCell setStringUploaderName:@"Alonso Holmes"];
        [footerCell setStringUploadDate:@"10 minutes ago"];
        [footerCell setStringUploaderProfileImage:[UIImage imageNamed:@"alonsoAvatar.jpg"]];
        [footerCell setCommentButtonTitle:@"4.7k"];
        [footerCell setLikeButtonTitle:@"11.3k"];
        
        return footerCell;
    } else {
        return nil; // this shouldn't happen but makes the compiler happy
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}




#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.5;
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
    [contentHeaderViewButton addTarget:self action:@selector(pushToStringDetailView) forControlEvents:UIControlEventTouchUpInside];
    [contentHeaderViewButton setAlpha:0.92];
    [contentHeaderViewButton setTitle:@"An awesome trip from coast to coast!" forState:UIControlStateNormal];
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




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    } else if (buttonIndex == 0) {
        NSLog(@"Removed Observers from selecting action sheet");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
        
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setDetailsEditable:YES];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];

        
        // Modal
        /*
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
        
        [self presentViewController:navVC animated:YES completion:nil];
         */
    } else if (buttonIndex == 1) {
        NSLog(@"Removed Observers from selecting action sheet");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
        
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setDetailsEditable:YES];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
        
        [self presentViewController:navVC animated:YES completion:nil];
         */
    } else if (buttonIndex == 2) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
    
    
}

@end
