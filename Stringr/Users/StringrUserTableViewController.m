//
//  StringrUserTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewController.h"
#import "StringrProfileViewController.h"
#import "StringrPathImageView.h"
#import "StringrUserTableViewCell.h"
#import "StringrStringDetailViewController.h"

@interface StringrUserTableViewController () <UIActionSheetDelegate>

@end

@implementation StringrUserTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:@"UploadNewString" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
}




#pragma mark - NSNotificationCenter Action Handlers

- (void)addNewString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Create New String"
                                                                      delegate:self
                                                             cancelButtonTitle:@"cancel"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"Take Photo", @"Choose From Existing", nil];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [newStringActionSheet showInView:self.view];
    } else {
        [newStringActionSheet showInView:window];
    }
    
}




#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // test number. This will eventually be pulled via the number of object's returned from parse
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UserProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrUserTableViewCell class]]) {
        
        StringrUserTableViewCell * userProfileCell = (StringrUserTableViewCell *)cell;
    
        // Creates the path and image for a profile thumbnail
        StringrPathImageView *cellProfileImage = (StringrPathImageView *)[self.view viewWithTag:1];
        [cellProfileImage setImageToCirclePath];
        [cellProfileImage setPathColor:[UIColor darkGrayColor]];
        [cellProfileImage setPathWidth:1.0];
        
        // Sets the profile image on the current cell
        // TODO: This will eventually be the profile image pulled from parse
        userProfileCell.ProfileThumbnailImageView = cellProfileImage;
        
        // Sets all of the information to the user results for this cell
        userProfileCell.profileDisplayNameLabel.text = @"Alonso Holmes";
        //userProfileCell.profileDisplayName = @"Alonso Holmes";
        //userProfileCell.profileUniversityName = @"Boston University";
        userProfileCell.profileUniversityNameLabel.text = @"Boston University";
        //userProfileCell.profileNumberOfStrings = 13;
        userProfileCell.profileNumberOfStringsLabel.text = @"13";
    }

    return cell;
}




#pragma mark - Table View Delegate

// Takes the user to the profile of the selected user cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Creates a new instance of a user profile
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    
    // Gets the cell that the user tapped on
    StringrUserTableViewCell *currentCell = (StringrUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    if (currentCell) {
        // Sets the title of the profile vc being pushed to that of the username on the cell being tapped
        profileVC.title = currentCell.profileDisplayNameLabel.text;
        
        profileVC.canGoBack = YES;
        profileVC.canEditProfile = NO;
        
        [profileVC setHidesBottomBarWhenPushed:YES];
        
       // profileVC.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Removed Observers from selecting action sheet");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
        
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
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
        
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    }
}


@end
