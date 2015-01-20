//
//  StringrSignUpWithSocialNetworkViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSignUpWithSocialNetworkViewController.h"
#import "StringrSelectProfileImageTableViewCell.h"
#import "StringrSetProfileDisplayNameTableViewCell.h"
#import "StringrAppViewController.h"
#import "StringrPathImageView.h"
#import "StringrAppDelegate.h"
#import "UIColor+StringrColors.h"
#import "StringrColoredView.h"

@interface StringrSignUpWithSocialNetworkViewController () <UIAlertViewDelegate>

@end

@implementation StringrSignUpWithSocialNetworkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.networkType == FacebookNetworkType) {
        self.title = @"Sign-Up with Facebook";
    } else if (self.networkType == TwitterNetworkType) {
        self.title = @"Sign-Up with Twitter";
    }
    
    //[self loadProfileImageFromSocialNetwork];

    UIBarButtonItem *signUpWithSocialNetworkBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(signUpWithSocialNetwork)];
    [self.navigationItem setRightBarButtonItem:signUpWithSocialNetworkBarButtonItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)signUpWithSocialNetwork
{
    if (self.username && self.displayName && self.password && self.reenteredPassword) {
        // used as an incremental boolean value. Every time a field is correct we increment it.
        // at the end we know how many field's should be correct so we can assess if the value
        // is equal to that value. The value should be 3 if all are correct
        int userIsValidForSignup = 0;
        NSString *errorString = @"";
        
        PFUser *newUser = [PFUser currentUser];
        
        if ([StringrUtility NSStringIsValidUsername:self.username]) {
            [newUser setObject:self.username forKey:kStringrUserUsernameCaseSensitive];
            [newUser setUsername:[self.username lowercaseString]];
            userIsValidForSignup++;
        }
        else {
            errorString = @"The username you entered is not valid!\n";
        }
        
        if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.displayName]) {
            [newUser setObject:self.displayName forKey:kStringrUserDisplayNameKey];

            userIsValidForSignup++;
        }
        else {
            errorString = [NSString stringWithFormat:@"%@The display name that you entered is not valid!\n", errorString];
        }
        
        if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.password]) {
            [newUser setPassword:self.password];
            userIsValidForSignup++;
        }
        else {
            errorString = [NSString stringWithFormat:@"%@The password you entered is not valid!\n", errorString];
        }
        
        if ([self.password isEqualToString:self.reenteredPassword]) {
            userIsValidForSignup++;
        }
        else {
            errorString = [NSString stringWithFormat:@"%@The passwords you entered do not match!", errorString];
        }
        
        if (userIsValidForSignup == 4) {
            [newUser setObject:@(YES) forKey:kStringrUserSocialNetworkSignupCompleteKey];
            [newUser setObject:@"" forKey:kStringrUserDescriptionKey];
            [newUser setObject:@(0) forKey:kStringrUserNumberOfPreviousActivitiesKey];
            
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[UIApplication appDelegate].appViewController signup];
                } else if (error.code == 202) { // 202 = username taken
                    UIAlertView *usernameTakenAlert = [[UIAlertView alloc] initWithTitle:@"Username Taken" message:@"The username you entered has already been taken!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [usernameTakenAlert show];
                } else if (error.code == 203) { // 203 = email address taken
                    UIAlertView *emailTakenAlert = [[UIAlertView alloc] initWithTitle:@"Email Taken" message:@"The email address you entered has already been taken!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [emailTakenAlert show];
                }
            }];
        } else {
            UIAlertView *invalidUserLogin = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [invalidUserLogin show];
        }
    } else {
        UIAlertView *invalidUserLogin = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Make sure that you filled out all of the sign-up information fields!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [invalidUserLogin show];
    }
}


- (void)cleanupSignup
{
    NSString *usernameCaseSensitive = [[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive];
    BOOL socialNetworkVerified = [[[PFUser currentUser] objectForKey:kStringrUserSocialNetworkSignupCompleteKey] boolValue];
    
    if (!usernameCaseSensitive && !socialNetworkVerified)
    {
        [[PFUser currentUser] deleteInBackground];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeProfileImage
{
    UIActionSheet *changeImage = [[UIActionSheet alloc] initWithTitle:@"Change Profile Image"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [changeImage addButtonWithTitle:@"Take Photo"];
    [changeImage addButtonWithTitle:@"Choose from Library"];
    
    NSInteger cancelButtonIndex = 2;
    
    if (self.networkType == FacebookNetworkType) {
        [changeImage addButtonWithTitle:@"Reload from Facebook"];
        cancelButtonIndex++;
    } else if (self.networkType == TwitterNetworkType) {
        [changeImage addButtonWithTitle:@"Reload from Twitter"];
        cancelButtonIndex++;
    }
    
    [changeImage addButtonWithTitle:@"Cancel"];
    [changeImage setCancelButtonIndex:cancelButtonIndex];
    
    [changeImage showInView:self.view];
}

// gets data for current users profile image data. Reloads profile image cell upon completion
- (void)loadProfileImageFromSocialNetwork
{
    PFFile *userProfileImageFile = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey];
    if (userProfileImageFile) {
        [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.userProfileImage = [UIImage imageWithData:imageData];
                NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[profileImageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"profilePicture_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSelectProfileImageTableViewCell class]]) {
            StringrSelectProfileImageTableViewCell *selectProfileImageCell = (StringrSelectProfileImageTableViewCell *)cell;
            
            [selectProfileImageCell.userProfileImage setImage:self.userProfileImage];
            [selectProfileImageCell.userProfileImage setImageToCirclePath];
            [selectProfileImageCell.userProfileImage setPathColor:[UIColor darkGrayColor]];
            [selectProfileImageCell.userProfileImage setPathWidth:1.0];
            
            return selectProfileImageCell;
        }
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor stringrLightGrayColor]];
        
    }
    else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"username_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;

            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"@Username..."];
            /*
            if (self.networkType == TwitterNetworkType) {
                [displayNameCell.setProfileDisplayNameTextField setText:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
            }
             */
            
            [displayNameCell.setProfileDisplayNameTextField setTag:1];
            
            return displayNameCell;
        }
    }
    else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"displayName_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Display Name..."];
            
            /*
            if (self.networkType == FacebookNetworkType || self.networkType == TwitterNetworkType) {
                [displayNameCell.setProfileDisplayNameTextField setText:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
            }
             */
            
            [displayNameCell.setProfileDisplayNameTextField setTag:2];
            
            return displayNameCell;
        }
    }
    else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor stringrLightGrayColor]];
    }
    else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"password_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Password..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:4];
            
            return displayNameCell;
        }
    }
    else if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"password_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Re-enter password..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:5];
            
            return displayNameCell;
        }
    }
    else {
        return nil;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.networkType == FacebookNetworkType) {
        return [StringrColoredView coloredViewWithColors:@[[UIColor facebookBlueColor]]];
        
    }
    else if (self.networkType == TwitterNetworkType) {
        return [StringrColoredView coloredViewWithColors:@[[UIColor twitterBlueColor]]];
    }
    
    return [StringrColoredView defaultColoredView];
}


#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // the text field's are associated via tag
    if (textField.tag == 1) {
        self.username = textField.text;
    }
    else if (textField.tag == 2) {
        self.displayName = textField.text;
    }
    else if (textField.tag == 4) {
        self.password = textField.text;
    }
    else if (textField.tag == 5) {
        self.reenteredPassword = textField.text;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:2];
        [nextTextField becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:4];
        [nextTextField becomeFirstResponder];
    }
    else if (textField.tag == 4) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:5];
        [nextTextField becomeFirstResponder];
    }
    else if (textField.tag == 5) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload from Facebook"] || [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload from Twitter"]) {
        [self loadProfileImageFromSocialNetwork];
    }
    
    // deselects the profile image select cell after an action sheet item is selected
    NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:profileImageIndexPath];
    [selectedCell setSelected:NO animated:YES];
}


#pragma mark - StringrLoginViewDownloadingSocialNetworkInfoDelegate

- (void)socialNetworkProfileImageDidFinishDownloading:(UIImage *)profileImage
{
    self.userProfileImage = profileImage;
    NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[profileImageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == !alertView.cancelButtonIndex)
    {
        [self cleanupSignup];
    }
}


@end
