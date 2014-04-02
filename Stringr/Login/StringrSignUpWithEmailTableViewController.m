//
//  StringrSignUpWithEmailTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSignUpWithEmailTableViewController.h"
#import "StringrEmailVerificationViewController.h"
#import "StringrSelectProfileImageTableViewCell.h"
#import "StringrSetProfileDisplayNameTableViewCell.h"
#import "StringrPathImageView.h"
#import "StringrPrivacyPolicyTermsOfServiceViewController.h"
#import "UIImage+Resize.h"
#import "StringrRootViewController.h"
#import "AppDelegate.h"


@interface StringrSignUpWithEmailTableViewController () 

@property (strong, nonatomic) PFFile *profileImageFile;
@property (strong, nonatomic) PFFile *profileThumbnailImageFile;
@property (weak, nonatomic) IBOutlet UIView *agreementView;

@end

@implementation StringrSignUpWithEmailTableViewController

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
    
    self.title = @"Sign-Up";
    //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.agreementView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    UIBarButtonItem *signupNavigationItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(signupWithUserInformation)];
    [self.navigationItem setRightBarButtonItem:signupNavigationItem];
    self.userProfileImage = [UIImage imageNamed:@"stringr_icon_filler"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // forces the back button to just be an <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
}


#pragma mark - Action's

- (void)selectProfileImage
{
    NSLog(@"touched button");
}




#pragma mark - IBAction's

- (IBAction)privacyPolicyButton:(UIButton *)sender
{
    StringrPrivacyPolicyTermsOfServiceViewController *privacyPolicyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"privacyPolicyToSVC"];
    [privacyPolicyVC setIsPrivacyPolicy:YES];
    UIBarButtonItem *privacyBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:privacyBarButtonItem];
    
    [self.navigationController pushViewController:privacyPolicyVC animated:YES];
}

- (IBAction)termsOfServiceButton:(UIButton *)sender
{
    StringrPrivacyPolicyTermsOfServiceViewController *privacyPolicyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"privacyPolicyToSVC"];
    [privacyPolicyVC setIsPrivacyPolicy:NO];
    UIBarButtonItem *privacyBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:privacyBarButtonItem];
    
    [self.navigationController pushViewController:privacyPolicyVC animated:YES];
}




#pragma mark - Private

- (void)signupWithUserInformation
{
    if (self.username && self.displayName && self.emailAddress && self.password) {
        // used as an incremental boolean value. Every time a field is correct we increment it.
        // at the end we know how many field's should be correct so we can assess if the value
        // is equal to that value. The value should be 4 if all are correct
        int userIsValidForSignup = 0;
        NSString *errorString = @"";
        
        PFUser *newUser = [PFUser user];
        
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
        
        if ([StringrUtility NSStringIsValidEmail:self.emailAddress]) {
            [newUser setEmail:self.emailAddress];
            userIsValidForSignup++;
        } else {
            errorString = [NSString stringWithFormat:@"%@The email address you entered is not valid!\n", errorString];
        }
        
        if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.password]) {
            [newUser setPassword:self.password];
            userIsValidForSignup++;
        } else {
            errorString = [NSString stringWithFormat:@"%@The password you entered is not valid!\n", errorString];
        }
        
        if (userIsValidForSignup == 4) {
            [newUser setObject:@(0) forKey:kStringrUserNumberOfStringsKey];
            [newUser setObject:@"Edit your profile to set the description." forKey:kStringrUserDescriptionKey];
            if (self.profileImageFile && self.profileThumbnailImageFile) {
                [newUser setObject:self.profileImageFile forKey:kStringrUserProfilePictureKey];
                [newUser setObject:self.profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];
            }
            /*
            else {
                 This sets the profile image and thumbnail to the stringr image. For now I am not implementing it because that is just
                 * a lot of wasted space on the server. By default the app displays that image for users without a profile pic.
                UIImage *resizedProfileImage = [[UIImage imageNamed:@"Stringr Image"] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) interpolationQuality:kCGInterpolationHigh];
                UIImage *thumbnailProfileImage = [[UIImage imageNamed:@"Stringr Image"] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
                
                NSData *profileImageData = UIImageJPEGRepresentation(resizedProfileImage, 0.8f);
                NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
                
                PFFile *profileImageFile = [PFFile fileWithName:@"profileImage.jpg" data:profileImageData];
                PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
                [newUser setObject:profileImageFile forKey:kStringrUserProfilePictureKey];
                [newUser setObject:profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];
                 
            }
                 */
            
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    // sets the new user to the current user
                    [PFUser becomeInBackground:newUser.sessionToken];
                    
                    if ((BOOL)[newUser objectForKey:@"emailVerified"] == YES) {
                        // instantiates the main logged in content area
                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        StringrEmailVerificationViewController *emailVerifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"emailVerificationVC"];
                        [emailVerifyVC setUserProfileImage:self.userProfileImage];
                        
                        // removes the signup page from the stack of vc's and pushes the email verification page on
                        UIViewController *loginVC = [self.navigationController.viewControllers objectAtIndex:0];
                        [self.navigationController setViewControllers:@[loginVC, emailVerifyVC] animated:YES];
                    }
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
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    [changeImage showInView:self.view];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
    } else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"username_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"@Username..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:1];
            
            return displayNameCell;
        }
    } else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"displayName_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Display Name..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:2];
            
            return displayNameCell;
        }
    } else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"seperator_cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    } else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"email_cell" forIndexPath:indexPath];
        
        if ([cell isKindOfClass:[StringrSetProfileDisplayNameTableViewCell class]]) {
            StringrSetProfileDisplayNameTableViewCell *displayNameCell = (StringrSetProfileDisplayNameTableViewCell *)cell;
            
            [displayNameCell.setProfileDisplayNameTextField setPlaceholder:@"Email Address..."];
            [displayNameCell.setProfileDisplayNameTextField setTag:3];
            
            return displayNameCell;
        }
    } else if (indexPath.row == 6) {
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



#pragma mark - TableView Delegate

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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerViewColoredLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 4.0f)];
    
    CGSize colorBlockSize = CGSizeMake(CGRectGetWidth(headerViewColoredLine.frame) / 7, 3.0f);
    
    for (int i = 0; i < 7; i++) {
        UIImageView *colorBlock = [[UIImageView alloc] initWithFrame:CGRectMake(i * colorBlockSize.width, 0, colorBlockSize.width, colorBlockSize.height)];
        
        UIColor *blockColor = [[UIColor alloc] init];
        switch (i) {
            case 0:
                blockColor = [StringrConstants kStringrRedColor];
                break;
            case 1:
                blockColor = [StringrConstants kStringrOrangeColor];
                break;
            case 2:
                blockColor = [StringrConstants kStringrYellowColor];
                break;
            case 3:
                blockColor = [StringrConstants kStringrGreenColor];
                break;
            case 4:
                blockColor = [StringrConstants kStringrTurquoiseColor];
                break;
            case 5:
                blockColor = [StringrConstants kStringrBlueColor];
                break;
            case 6:
                blockColor = [StringrConstants kStringrPurpleColor];
                break;
            default:
                break;
        }
        
        [colorBlock setBackgroundColor:blockColor];
        [headerViewColoredLine addSubview:colorBlock];
    }
        
        return headerViewColoredLine;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0f;
}
 

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self changeProfileImage];
    }
}



#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // the text field's are associated via tag
    if (textField.tag == 1) {
        self.username = textField.text;
    } else if (textField.tag == 2) {
        self.displayName = textField.text;
    } else if (textField.tag == 3) {
        self.emailAddress = textField.text;
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
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:3];
        [nextTextField becomeFirstResponder];
    } else if (textField.tag == 3) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag:4];
        [nextTextField becomeFirstResponder];
    } else if (textField.tag == 4) {
        [textField resignFirstResponder];
    }
    
    return YES;
}




#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Library"]) {
        UIImagePickerController *imagePickerController= [[UIImagePickerController alloc]init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        // image picker needs a delegate so we can respond to its messages
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}




#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
        
        // resizes the image into a normal and thumbnail sized photo for uploading
        UIImage *resizedProfileImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) interpolationQuality:kCGInterpolationHigh];
        UIImage *thumbnailProfileImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
        
        self.userProfileImage = resizedProfileImage;
        
        NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[profileImageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        // Creates a data representation of the newly selected profile image
        // Saves that image to the current users parse user profile
        NSData *profileImageData = UIImageJPEGRepresentation(resizedProfileImage, 0.8f);
        NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
        
        // saves the PFFile for later after the user user has opted to sign-up
        self.profileImageFile = [PFFile fileWithName:@"profileImage.jpg" data:profileImageData];
        self.profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
    }];
}



@end
