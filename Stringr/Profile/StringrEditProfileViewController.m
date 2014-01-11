//
//  StringrEditProfileViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrEditProfileViewController.h"
#import "StringrProfileViewController.h"

@interface StringrEditProfileViewController () <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet StringrPathImageView *editProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *editProfileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *editProfileDescriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *charactersRemaining;
@property (weak, nonatomic) IBOutlet UITextField *underlyingProfileDescriptionTextField;


@end

@implementation StringrEditProfileViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Adds a custom path to the profile image
    [self.editProfileImage setImageToCirclePath];
    [self.editProfileImage setPathWidth:1.0];
    [self.editProfileImage setPathColor:[UIColor darkGrayColor]];

    
    // Adds notifications to know when the keyboard is shown and hidden
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Adds a tap gesture for the ability to tap the profile image UIImageView
    UITapGestureRecognizer *tapImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfileImage)];
    tapImageGesture.delegate = self;
    [self.editProfileImage addGestureRecognizer:tapImageGesture];
    
    [self.editProfileNameTextField setPlaceholder:self.fillerProfileName];
    [self.editProfileDescriptionTextView setText:self.fillerDescription];
    [self.editProfileImage setImage:self.fillerProfileImage.image];
    
    NSString *charactersRemaining = [NSString stringWithFormat:@"%u", 60 - self.editProfileDescriptionTextView.text.length];
    [self.charactersRemaining setText:charactersRemaining];
    
}


#pragma mark - UIControls

// Sets the delegate profile name to the edited text of the UITextField
- (IBAction)editProfileNameTextField:(UITextField *)sender
{
    NSString *editedName = sender.text;
    [self.delegate setProfileName:editedName];
}




#pragma mark - UIGestureRecognizerDelegate

- (void)changeProfileImage
{
    UIActionSheet *changeImage = [[UIActionSheet alloc] initWithTitle:@"Change Profile Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose From Library", @"Take Photo", nil];
    
    [changeImage showInView:self.view];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate

#define kNUMBER_OF_CHARACTERS_ALLOWED 60
/* Removes all text from the view upon tapping the textview
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
*/

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



#pragma mark - Keyboard Notification

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





@end
