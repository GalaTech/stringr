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
#import "StringrUtility.h"

@interface StringrUserTableViewController ()

@end

@implementation StringrUserTableViewController


- (void)viewDidLoad
{
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}


// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
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
        
       // profileVC.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}


@end
