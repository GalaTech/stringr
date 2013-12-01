//
//  StringrUserTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewController.h"
#import "StringrProfileViewController.h"
#import "GBPathImageView.h"
#import "StringrUserTableViewCell.h"

@interface StringrUserTableViewController ()

@end

@implementation StringrUserTableViewController


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UserProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrUserTableViewCell class]]) {
        
        StringrUserTableViewCell * userProfileCell = (StringrUserTableViewCell *)cell;
    
        // Creates the path and image for a profile thumbnail
        GBPathImageView *image1 = (GBPathImageView *)[self.view viewWithTag:1];
        [image1 setPathColor:[UIColor whiteColor]];
        [image1 setBorderColor:[UIColor darkGrayColor]];
        [image1 setPathWidth:2.0];
        [image1 setPathType:GBPathImageViewTypeCircle];
        [image1 draw];
        
        userProfileCell.ProfileThumbnailImageView = image1;
        
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
        
        profileVC.view.backgroundColor = [UIColor blackColor];
        
        [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:profileVC animated:YES];
    }
}


@end
