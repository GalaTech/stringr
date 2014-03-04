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
#import "UIImage+Resize.h"


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
    
    NSString *charactersRemaining = [NSString stringWithFormat:@"%u", 60 - self.editProfileDescriptionTextView.text.length];
    [self.charactersRemaining setText:charactersRemaining];
    
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) + 300)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //#warning removed keyboard placement actions because I added full scrollview
    // Adds notifications to know when the keyboard is shown and hidden
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Custom Accessors

/*
- (void)setEditProfileImage:(StringrPathImageView *)editProfileImage
{
    _editProfileImage = editProfileImage;
    
    [self.delegate setProfilePhoto:_editProfileImage.image];
}
*/


#pragma mark - Actions

- (void)changeProfileImage
{
    UIActionSheet *changeImage = [[UIActionSheet alloc] initWithTitle:@"Change Profile Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose from Library", @"Reload from Facebook", nil];
    [changeImage showInView:self.view];
}




#pragma mark - IBActions

// Sets the delegate profile name to the edited text of the UITextField
- (IBAction)editProfileNameTextField:(UITextField *)sender
{
    NSString *editedName = sender.text;
    [self.delegate setProfileName:editedName];
    [[PFUser currentUser] setObject:editedName forKey:kStringrUserDisplayNameKey];
    // saves with block so that the menu will only reload once the data has been successfully uploaded
    [[PFUser currentUser] saveInBackground];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUpdateMenuProfileName object:editedName];
    
}

- (IBAction)selectUniversityButtonAction:(UIButton *)sender
{
    NSArray *array = [[PFUser currentUser] objectForKey:kStringrUserUniversitiesKey];
    
    UIActionSheet *universitySelectActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your University" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *title in array) {
        [universitySelectActionSheet addButtonWithTitle:title];
    }
    
    [universitySelectActionSheet addButtonWithTitle:@"Cancel"];
    [universitySelectActionSheet setCancelButtonIndex:[array count]];
    
    
    [universitySelectActionSheet showInView:self.view];
}




#pragma mark - NSNotificationCenter Action Handlers


- (void)keyboardWillShow:(NSNotification *)note {
    // Gets the rect of the keyboard
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Gets the size of the scroll view
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    
    // Sets the height of our CG size to add the height of the keyboard
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    
    // Sets the content size of the scroll view to our newly created CGSize
    [self.scrollView setContentSize:scrollViewContentSize];
    
    // Creates a point to move the scroll view to adjust for the keyboard.
    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    scrollViewContentOffset.y += keyboardFrameEnd.size.height;
    scrollViewContentOffset.y -= 80.0f;
    
    // Moves the scroll view to the new content offset in an animated fashion.
    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
}




#pragma mark - Private

- (void)downloadFacebookProfileImage
{
    // Download the user's facebook profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:kStringrFacebookProfilePictureURLKey]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:kStringrFacebookProfilePictureURLKey]];
        
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

/*
- (void)setupAndDisplayUniversitySelectView
{

}
 */



#pragma mark - UITableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    }
    
    switch (indexPath.section) {
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_ProfileName" forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_ProfileDescription" forIndexPath:indexPath];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"editProfile_SelectUniversity" forIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewController Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            //[self setupAndDisplayUniversitySelectView];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // The section for changing profile image does not have a section header
    if (section == 0) {
        return 0;
    } else {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    
    // The section for changing profile image does not have a section header
    if (section > 0) {
         headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
        [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
        UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 200, 15)];
        
        // SectionHeaderTitles is pulled from photo/string subclasses getter
        switch (section) {
            case 0:
                [headerText setText:nil];
                break;
            case 1:
                [headerText setText:@"Profile Name"];
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
            return 128;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 125;
            break;
        case 3:
            return 55;
            break;
        default:
            break;
    }
    
    return 500;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate

static int const kNUMBER_OF_CHARACTERS_ALLOWED = 60;

// Sets the filler description to the text of the view whenever you exit
- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = self.fillerDescription;
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
        
        
        // ensures that the description is not empty
        if (textView.text.length > 0) {
            // Sets the delegates description to the text views text. This will change the description that
            // is displayed on the main profile page.
            [self.delegate setProfileDescription:textView.text];
            [[PFUser currentUser] setObject:textView.text forKey:kStringrUserDescriptionKey];
            [[PFUser currentUser] saveInBackground];
        
            self.fillerDescription = textView.text;
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    
    // Creates a string with the number of characters remaining and sets it to the
    // characters remaining label on the view
    NSString *charactersRemaining = [NSString stringWithFormat:@"%d", kNUMBER_OF_CHARACTERS_ALLOWED - numberRemainging];
    self.charactersRemaining.text = charactersRemaining;
    
    return YES;
}





#pragma mark - UIScrollViewDelegate


// Hides the keyboard if you begin to move the scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.editProfileNameTextField resignFirstResponder];
    [self.editProfileDescriptionTextView resignFirstResponder];

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
        
        [self downloadFacebookProfileImage];
        
    } else {
        if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
            NSString *selectedUniversityName = [actionSheet buttonTitleAtIndex:buttonIndex];
            
            // if not equal to the currently selected university name
            if (![selectedUniversityName isEqualToString:self.selectUniversityButton.titleLabel.text]) {
                [self.selectUniversityButton setTitle:selectedUniversityName forState:UIControlStateNormal];
                
                [self.delegate setProfileUniversityName:selectedUniversityName];
                
                [[PFUser currentUser] setObject:selectedUniversityName forKey:kStringrUserSelectedUniversityKey];
                [[PFUser currentUser] saveInBackground];
            }
        }
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
        
        // Creates a data representation of the newly selected profile image
        // Saves that image to the current users parse user profile
        NSData *profileImageData = UIImageJPEGRepresentation(resizedProfileImage, 0.8f);
        NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
        
        PFFile *profileImageFile = [PFFile fileWithName:@"profileImage.jpg" data:profileImageData];
        PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
        
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
    
    //UIImage *resizedProfileImage = [facebookProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailProfileImage = [facebookProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    
    NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
    
    // Saves the users Facebook profile image as a parse file once the data has been loaded
    PFFile *profileImageFile = [PFFile fileWithName:@"profileImage.png" data:self.profileImageData];
    PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
    [[PFUser currentUser] setObject:profileImageFile forKey:kStringrUserProfilePictureKey];
    [[PFUser currentUser] setObject:profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];
    
    [[PFUser currentUser] saveInBackground];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUpdateMenuProfileImage object:facebookProfileImage];
}

@end
