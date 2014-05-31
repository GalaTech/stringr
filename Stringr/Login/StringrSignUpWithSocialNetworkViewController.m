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
#import "StringrRootViewController.h"
#import "StringrPathImageView.h"
#import "AppDelegate.h"

@interface StringrSignUpWithSocialNetworkViewController ()

@end

@implementation StringrSignUpWithSocialNetworkViewController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    if (self.username && self.displayName && self.password) {
        // used as an incremental boolean value. Every time a field is correct we increment it.
        // at the end we know how many field's should be correct so we can assess if the value
        // is equal to that value. The value should be 4 if all are correct
        int userIsValidForSignup = 0;
        NSString *errorString = @"";
        
        PFUser *newUser = [PFUser currentUser];
        
        if ([StringrUtility NSStringIsValidUsername:self.username]) {
            [newUser setObject:self.username forKey:kStringrUserUsernameCaseSensitive];
            [newUser setUsername:[self.username lowercaseString]];
            userIsValidForSignup++;
        } else {
            errorString = @"The username you entered is not valid!\n";
        }
        
        if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.displayName]) {
            [newUser setObject:self.displayName forKey:kStringrUserDisplayNameKey];

            userIsValidForSignup++;
        } else {
            errorString = [NSString stringWithFormat:@"%@The display name that you entered is not valid!\n", errorString];
        }
        
        if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.password]) {
            [newUser setPassword:self.password];
            userIsValidForSignup++;
        } else {
            errorString = [NSString stringWithFormat:@"%@The password you entered is not valid!\n", errorString];
        }
        
        if (userIsValidForSignup == 3) {
            [newUser setObject:@(YES) forKey:kStringrUserSocialNetworkSignupCompleteKey];
            [newUser setObject:@(0) forKey:kStringrUserNumberOfStringsKey];
            [newUser setObject:@"Edit your profile to set the description." forKey:kStringrUserDescriptionKey];
            
            
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // instantiates the main logged in content area
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
                    
                    [self dismissViewControllerAnimated:YES completion:^ {
                        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                            if (!error) {
                                [[PFUser currentUser] setObject:geoPoint forKey:@"geoLocation"];
                                
                                NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [[PFUser currentUser] objectId]];
                                [[PFUser currentUser] setObject:privateChannelName forKey:kStringrUserPrivateChannelKey];
                                
                                [[PFUser currentUser] saveInBackground];
                                
                                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kStringrInstallationUserKey];
                                [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
                                [[PFInstallation currentInstallation] saveEventually];
                            }
                        }];
                    }];
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
    return 6;
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
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
    } else if (indexPath.row == 2) {
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
    } else if (indexPath.row == 3) {
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
    } else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    } else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"password_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Password..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:4];
            
            return displayNameCell;
        }
    } else {
        return nil;
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            return 128.0f;
            break;
        case 1:
            return 3.0f;
            break;
        case 4:
            return 3.0f;
            break;
        default:
            return 46.0f;
            break;
    }
}
*/
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerViewColoredLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 4.0f)];
    
    if (self.networkType == FacebookNetworkType) {
        UIImageView *facebookBarColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headerViewColoredLine.frame), CGRectGetHeight(headerViewColoredLine.frame))];
        [facebookBarColorImageView setBackgroundColor:[UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0]];
        [headerViewColoredLine addSubview:facebookBarColorImageView];
    } else if (self.networkType == TwitterNetworkType) {
        UIImageView *twitterBarColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headerViewColoredLine.frame), CGRectGetHeight(headerViewColoredLine.frame))];
        [twitterBarColorImageView setBackgroundColor:[UIColor colorWithRed:64/255.0f green:153/255.0f blue:255/255.0f alpha:1.0]];
        [headerViewColoredLine addSubview:twitterBarColorImageView];
    }
    
    return headerViewColoredLine;
}




#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // the text field's are associated via tag
    if (textField.tag == 1) {
        self.username = textField.text;
    } else if (textField.tag == 2) {
        self.displayName = textField.text;
    } else if (textField.tag == 4) {
        self.password = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:2];
        [nextTextField becomeFirstResponder];
    } else if (textField.tag == 2) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:4];
        [nextTextField becomeFirstResponder];
    } else if (textField.tag == 4) {
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

@end
