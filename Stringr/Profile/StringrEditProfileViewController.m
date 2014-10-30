//
//  StringrEditProfileViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrEditProfileViewController.h"
#import "StringrProfileViewController.h"
#import "StringrSelectProfileImageTableViewCell.h"
#import "StringrSetProfileDisplayNameTableViewCell.h"
#import "StringrSetProfileDescriptionTableViewCell.h"
#import "StringrPathImageView.h"
#import "UIImage+Resize.h"
#import "UIColor+StringrColors.h"


@interface StringrEditProfileViewController () <UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet StringrPathImageView *editProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *editProfileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *editProfileDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemaining;
@property (weak, nonatomic) IBOutlet UITextField *underlyingProfileDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectUniversityButton;

@property (strong, nonatomic) NSMutableData *profileImageData;

@end

@implementation StringrEditProfileViewController

#pragma mark - Lifecycle

- (void) dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    
    // Adds a custom path to the profile image
    [self.editProfileImage setImageToCirclePath];
    [self.editProfileImage setPathWidth:1.0];
    [self.editProfileImage setPathColor:[UIColor darkGrayColor]];

    
    // Adds a tap gesture for the ability to tap the profile image UIImageView
    UITapGestureRecognizer *tapImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfileImage)];
    tapImageGesture.delegate = self;
    [self.editProfileImage addGestureRecognizer:tapImageGesture];
    
    [self.editProfileNameTextField setPlaceholder:self.fillerProfileName];
    [self.editProfileDescriptionTextView setText:self.fillerDescription];
    [self.editProfileImage setImage:self.fillerProfileImage.image];
    
    [self.selectUniversityButton setTitle:self.fillerUniversityName forState:UIControlStateNormal];
    
    NSString *charactersRemaining = [NSString stringWithFormat:@"%lu", kNUMBER_OF_CHARACTERS_ALLOWED - self.editProfileDescriptionTextView.text.length];
    [self.charactersRemaining setText:charactersRemaining];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}



#pragma mark - Actions

- (void)changeProfileImage
{
    UIActionSheet *changeImage = [[UIActionSheet alloc] initWithTitle:@"Change Profile Image"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    
    int numberOfButtons = 2;
    
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [changeImage addButtonWithTitle: @"Reload from Facebook"];
        numberOfButtons++;
    }
    
    if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
        [changeImage addButtonWithTitle:@"Reload from Twitter"];
        numberOfButtons++;
    }
    
    [changeImage addButtonWithTitle:@"Cancel"];
    
    [changeImage setCancelButtonIndex:numberOfButtons];
    
    [changeImage showInView:self.view];
}



#pragma mark - Private

- (void)downloadSocialNetworkProfileImage
{
    // Download the user's facebook profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ( ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] || [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]] ) && [[PFUser currentUser] objectForKey:kStringrUserProfilePictureURLKey] ) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:kStringrUserProfilePictureURLKey]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }
}



#pragma mark - UITableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_ProfileImage" forIndexPath:indexPath];
        
        StringrSelectProfileImageTableViewCell *imageCell = (StringrSelectProfileImageTableViewCell *)cell;
        
        [imageCell.userProfileImage setImage:self.fillerProfileImage.image];
        [imageCell.userProfileImage setImageToCirclePath];
        [imageCell.userProfileImage setPathColor:[UIColor darkGrayColor]];
        [imageCell.userProfileImage setPathWidth:1.0];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_ProfileName" forIndexPath:indexPath];
        
        StringrSetProfileDisplayNameTableViewCell *setDisplayName = (StringrSetProfileDisplayNameTableViewCell *)cell;
        
        [setDisplayName.setProfileDisplayNameTextField setPlaceholder:self.fillerProfileName];
        
        
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_ProfileDescription" forIndexPath:indexPath];
        
        StringrSetProfileDescriptionTableViewCell *setDescriptionText = (StringrSetProfileDescriptionTableViewCell *)cell;
        
        [setDescriptionText.setProfileDescriptionTextView setText:self.fillerDescription];
        
        // Sets the number of characters remaining based around the length of text
        NSString *charactersRemaining = [NSString stringWithFormat:@"%lu", kNUMBER_OF_CHARACTERS_ALLOWED - setDescriptionText.setProfileDescriptionTextView.text.length];
        [setDescriptionText.numberOfCharactersRemainingLabel setText:charactersRemaining];
        
    }

    
    return cell;
}



#pragma mark - UITableViewController Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self changeProfileImage];
        
        //StringrSelectProfileImageTableViewCell *profileImageCell = (StringrSelectProfileImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //[profileImageCell.userProfileImage setImage:self.editProfileImage.image];
        
    } else if (indexPath.section == 3) {

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // The section for changing profile image does not have a section header
    if (section == 0) {
        return 0.0f;
    } else {
        return 20.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    
    // The section for changing profile image does not have a section header
    if (section > 0) {
         headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
        [headerView setBackgroundColor:[UIColor stringrLightGrayColor]];
        
        UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 200, 15)];
        
        // SectionHeaderTitles is pulled from photo/string subclasses getter
        switch (section) {
            case 0:
                [headerText setText:nil];
                break;
            case 1:
                [headerText setText:@"Display Name"];
                break;
            case 2:
                [headerText setText:@"Profile Description"];
                break;
            case 3:
                [headerText setText:@"University"];
                break;
            default:
                break;
        }
        
        [headerText setTextColor:[UIColor darkGrayColor]];
        [headerText setTextAlignment:NSTextAlignmentLeft];
        [headerText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        
        [headerView addSubview:headerText];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 128.0f;
            break;
        case 1:
            return 44.0f;
            break;
        case 2:
            return 125.0f;
            break;
        case 3:
            return 55.0f;
            break;
        default:
            break;
    }
    
    return 500.0f;
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textField.text]) {
        NSString *editedName = textField.text;
        self.fillerProfileName = editedName;
        [self.delegate setProfileName:editedName];
        [[PFUser currentUser] setObject:editedName forKey:kStringrUserDisplayNameKey];
        
        //NSString *lowercaseName = [editedName lowercaseString];
        //[[PFUser currentUser] setObject:lowercaseName forKey:kStringrUserDisplayNameCaseInsensitiveKey];
        // saves with block so that the menu will only reload once the data has been successfully uploaded
        [[PFUser currentUser] saveInBackground];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUpdateMenuProfileName object:editedName];
        //NSLog(@"test");
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textField.text]) {
        textField.placeholder = self.fillerProfileName;
        textField.text = @"";
    }
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - UITextViewDelegate

static int const kNUMBER_OF_CHARACTERS_ALLOWED = 100;

// Sets the filler description to the text of the view whenever you exit
- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Accounts for the correct filler text and character remaining count
    if (![StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textView.text]) {
        textView.text = self.fillerDescription;
        
        // calculates the accurate number of characters remaining
        NSInteger numberRemainging = kNUMBER_OF_CHARACTERS_ALLOWED - textView.text.length;
        NSString *charactersRemaining = [NSString stringWithFormat:@"%ld", (long)numberRemainging];
        
        NSIndexPath *profileDescriptionIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        StringrSetProfileDescriptionTableViewCell *descriptionCell = (StringrSetProfileDescriptionTableViewCell *)[self.tableView cellForRowAtIndexPath:profileDescriptionIndexPath];
        
        [descriptionCell.numberOfCharactersRemainingLabel setText:charactersRemaining];
    }
     
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // calculates the accurate number of characters remaining
    NSInteger numberRemainging = [[textView text] length] - range.length + text.length;
    
    // Hides the keyboard when the user presses the return key
    if([text isEqualToString:@"\n"]) {
        
        // Makes sure that the description entered is not too long
        if (textView.text.length >= kNUMBER_OF_CHARACTERS_ALLOWED + 1) {
            UIAlertView *descriptionTooLongAlert = [[UIAlertView alloc] initWithTitle:@"Too many characters!"
                                                                              message:@"Your description has too many characters!"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles: nil];
            [descriptionTooLongAlert show];
            return NO;
        }
        
        NSCharacterSet *noCharacters = [NSCharacterSet whitespaceCharacterSet];
        
        NSArray *textWords = [textView.text componentsSeparatedByCharactersInSet:noCharacters];
        NSString *textWithoutWhiteSpace = [textWords componentsJoinedByString:@""];
        
        // ensures that the description is not empty
        if (textWithoutWhiteSpace.length > 0) {
            // Sets the delegates description to the text views text. This will change the description that
            // is displayed on the main profile page.
            [self.delegate setProfileDescription:textView.text];
            self.fillerDescription = textView.text;
            // Saves description to parse user object
            [[PFUser currentUser] setObject:textView.text forKey:kStringrUserDescriptionKey];
            [[PFUser currentUser] saveInBackground];
        
            
        }
        
        [textView resignFirstResponder];
        return NO;
    }

    // Creates a string with the number of characters remaining and sets it to the
    // characters remaining label on the view
    NSString *charactersRemaining = [NSString stringWithFormat:@"%ld", kNUMBER_OF_CHARACTERS_ALLOWED - numberRemainging];
    
    NSIndexPath *profileDescriptionIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    StringrSetProfileDescriptionTableViewCell *descriptionCell = (StringrSetProfileDescriptionTableViewCell *)[self.tableView cellForRowAtIndexPath:profileDescriptionIndexPath];
    
    [descriptionCell.numberOfCharactersRemainingLabel setText:charactersRemaining];
    
    //self.charactersRemaining.text = charactersRemaining;
    
    return YES;
}



#pragma mark - UIScrollViewDelegate


// Hides the keyboard if you begin to move the scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // resigns first responder for all
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
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload from Facebook"]) {
        
        [self downloadSocialNetworkProfileImage];
        
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reload from Twitter"]) {
        [self downloadSocialNetworkProfileImage];
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
        
        // sets new image to the edit page and the profile page
        [self.editProfileImage setImage:resizedProfileImage];
        [self.delegate setProfilePhoto:resizedProfileImage];
        
        // Sets the cells image to the newly selected image
        NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[profileImageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Creates a data representation of the newly selected profile image
        // Saves that image to the current users parse user profile
        NSData *profileImageData = UIImageJPEGRepresentation(resizedProfileImage, 0.8f);
        NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
        
        PFFile *profileImageFile = [PFFile fileWithName:@"profileImage.jpeg" data:profileImageData];
        PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
        
        [profileImageFile saveInBackground];
        [profileThumbnailImageFile saveInBackground];
        
        [[PFUser currentUser] setObject:profileImageFile forKey:kStringrUserProfilePictureKey];
        [[PFUser currentUser] setObject:profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];

        [[PFUser currentUser] saveInBackground];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUpdateMenuProfileImage object:resizedProfileImage];
        
    }];
}



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *facebookProfileImage = [UIImage imageWithData:self.profileImageData];
    
    [self.editProfileImage setImage:facebookProfileImage];
    [self.delegate setProfilePhoto:facebookProfileImage];
    
    // Sets the cells image to the newly selected image
    NSIndexPath *profileImageIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[profileImageIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //UIImage *resizedProfileImage = [facebookProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailProfileImage = [facebookProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    
    NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
    
    // Saves the users Facebook profile image as a parse file once the data has been loaded
    PFFile *profileImageFile = [PFFile fileWithName:@"profileImage.png" data:self.profileImageData];
    PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
    
    [profileImageFile saveInBackground];
    [profileThumbnailImageFile saveInBackground];
    
    [[PFUser currentUser] setObject:profileImageFile forKey:kStringrUserProfilePictureKey];
    [[PFUser currentUser] setObject:profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];
    
    [[PFUser currentUser] saveInBackground];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUpdateMenuProfileImage object:facebookProfileImage];
}

@end
