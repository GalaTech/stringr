//
//  StringrLoginViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrLoginViewController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrAppViewController.h"
#import "UIImage+Resize.h"
#import "StringrSignUpWithEmailTableViewController.h"
#import "StringrSignUpWithSocialNetworkViewController.h"
#import "StringrLoginWithEmailTableViewController.h"
#import "ILTranslucentView.h"
#import "StringrEmailVerificationViewController.h"
#import "StringrNavigationController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrStringTableViewController.h"
#import "StringrAppDelegate.h"

//#import "StringrProfileViewController.h"

static NSString * const StringrLoginStoryboard = @"StringrLoginViewStoryboard";

@interface StringrLoginViewController () <UIAlertViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *usernameBlurredView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *passwordBlurredView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) UIImage *userProfileImage;

@property (weak, nonatomic) IBOutlet UIButton *userNeedsToVerifyEmailButton;


@property (nonatomic) int imageNumber;
@property (strong, nonatomic) NSTimer *backgroundRotationTimer;
@property (strong, nonatomic) NSMutableArray *universityNames;
@property (strong, nonatomic) NSMutableData *profileImageData;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation StringrLoginViewController

#pragma mark - Lifecycle

+ (StringrLoginViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrLoginStoryboard bundle:nil];
    return (StringrLoginViewController *)[storyboard instantiateInitialViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.loginActivityIndicator startAnimating];
    // prevents a user from tapping the login button before it checks to see if you're already connected
    //[self.facebookLoginButton setUserInteractionEnabled:NO];
    //[self.userNeedsToVerifyEmailButton setUserInteractionEnabled:NO];
    
    [self setupBlurredUsernameAndPasswordBackgrounds];
    [self setupTextFieldDesign];
    
    [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(loginUserFromRefresh)];

    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    // Sets the appearance of the navigation bar items
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f]
                                                            }];
    
    // forces the back button to just be an <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.imageNumber = 1;
    
    NSTimeInterval time = 10.0;
    self.backgroundRotationTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(changeBackgroundImage) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.backgroundRotationTimer invalidate];
}


#pragma mark - Action Handlers

- (void)changeBackgroundImage
{
    NSString *imageName = @"stockImage*";
    
    // determines which stock image to use next
    switch (self.imageNumber) {
        case 1:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"1"];
            self.imageNumber++;
            break;
        case 2:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"2"];
            self.imageNumber++;
            break;
        case 3:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"3"];
            self.imageNumber++;
            break;
        case 4:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"4"];
            self.imageNumber++;
            break;
        case 5:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"5"];
            self.imageNumber++;
            break;
        case 6:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"6"];
            self.imageNumber = 1;
            break;
        default:
            break;
    }
    
    // Transitions between the different stock images with a slow cross dissolve
    [UIView transitionWithView:self.backgroundImageView
                      duration:3.0 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.backgroundImageView setImage:[UIImage imageNamed:imageName]];
                    } completion:nil];
}

- (void)dismissKeyboard
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}



#pragma mark - IBActions

- (IBAction)loginWithFacebookButtonTouchHandler:(UIButton *)sender
{
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        //[self presentCheckYourInternetConnectionAlertView];
        return;
    }
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"basic_info"];
    
    // Show loading indicator until login is finished
    [self.loginActivityIndicator startAnimating];

    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // Hide loading indicator
        [self.loginActivityIndicator stopAnimating];
        
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                //[alert show];
            }
        } else if (user.isNew) {
            [self userFacebookLoginData];
            StringrSignUpWithSocialNetworkViewController *facebookSignUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSignupWithSocialNetworkID];
            [facebookSignUpVC setNetworkType:FacebookNetworkType];
            [self setDelegate:facebookSignUpVC];
            [self.navigationController pushViewController:facebookSignUpVC animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            
            if ([StringrUtility facebookUserCanLogin:user]) {
                // instantiates the main logged in content area
//                [(StringrAppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate logInViewController:self didLogInUser:user];
            } else {
                [self.userNeedsToVerifyEmailButton setHidden:YES];
                StringrSignUpWithSocialNetworkViewController *facebookSignUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSignupWithSocialNetworkID];
                [facebookSignUpVC setNetworkType:FacebookNetworkType];
                [self setDelegate:facebookSignUpVC];
                [self.navigationController pushViewController:facebookSignUpVC animated:YES];
            }
        }
    }];
}

- (IBAction)loginWithTwitterButtonTouchHandler:(UIButton *)sender
{
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        //[self presentCheckYourInternetConnectionAlertView];
        return;
    }
    
    // Show loading indicator until login is finished
    [self.loginActivityIndicator startAnimating];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        [self.loginActivityIndicator stopAnimating];
        
        if (!user) {
            NSLog(@"The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self userTwitterLoginData];
            StringrSignUpWithSocialNetworkViewController *twitterSignUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSignupWithSocialNetworkID];
            [twitterSignUpVC setNetworkType:TwitterNetworkType];
            [self setDelegate:twitterSignUpVC];
            [self.navigationController pushViewController:twitterSignUpVC animated:YES];
        } else {
            NSLog(@"User logged in with Twitter!");
            
            if ([StringrUtility twitterUserCanLogin:user]) {
                // instantiates the main logged in content area
//                [(StringrAppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate logInViewController:self didLogInUser:user];
            } else {
                [self.userNeedsToVerifyEmailButton setHidden:YES];
                StringrSignUpWithSocialNetworkViewController *twitterSignUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSignupWithSocialNetworkID];
                [twitterSignUpVC setNetworkType:TwitterNetworkType];
                [self setDelegate:twitterSignUpVC];
                [self.navigationController pushViewController:twitterSignUpVC animated:YES];
            }
        }
    }];
}

- (IBAction)signUpWithEmailButtonTouchHandler:(UIButton *)sender
{
    StringrSignUpWithEmailTableViewController *signupWithEmailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSignupWithEmailID];
    
    [self.navigationController pushViewController:signupWithEmailVC animated:YES];
}

- (IBAction)loginWithEmailButtonTouchHandler:(UIButton *)sender
{
    [self.loginActivityIndicator startAnimating];
    [PFUser logInWithUsernameInBackground:self.username
                                 password:self.userPassword
                                   target:self
                                 selector:@selector(handleUserLogin:withError:)];
}

- (IBAction)userNeedsToVerifyEmailButtonTouchHandler:(UIButton *)sender
{
    StringrEmailVerificationViewController *emailVerificationVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEmailVerificationID];
    [self.navigationController pushViewController:emailVerificationVC animated:YES];
}



#pragma mark - Private

// logs in the user after the refresh is complete on the current user
- (void)loginUserFromRefresh
{
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        //[self presentCheckYourInternetConnectionAlertView];
        return;
    }
    
    // shows or hides the email icon based around whether or not the current user has verified their email
    BOOL setHidden = ![StringrUtility usernameUserNeedsToVerifyEmail:[PFUser currentUser]];
    [self.userNeedsToVerifyEmailButton setHidden:setHidden];
    [self.loginActivityIndicator startAnimating];
    
    // delay time for check so that there is not a error with the navigation
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     
        //[self.loginActivityIndicator stopAnimating];
        [self.facebookLoginButton setUserInteractionEnabled:YES];
        [self.userNeedsToVerifyEmailButton setUserInteractionEnabled:YES];
        
        // Check if user is cached and linked to Facebook, twitter, or email, if so, bypass login
        if ([StringrUtility facebookUserCanLogin:[PFUser currentUser]] || [StringrUtility twitterUserCanLogin:[PFUser currentUser]] || [StringrUtility usernameUserCanLogin:[PFUser currentUser]]) { // if the user is a facebook user
//            [(StringrAppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
            [self.loginActivityIndicator stopAnimating];
            [self dismissViewControllerAnimated:YES completion:^ {
                [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] setObject:geoPoint forKey:@"geoLocation"];
                        
                        // Saves the user after we have ensured they are a valid college student
                        [[PFUser currentUser] saveInBackground];
                    }
                }];
            }];
            
            
            
            // alert delegate that we logged in with user
            [self.delegate logInViewController:self didLogInUser:[PFUser currentUser]];
        } else if ([StringrUtility usernameUserNeedsToVerifyEmail:[PFUser currentUser]]) { // if the user has not verified their email
            StringrEmailVerificationViewController *emailVerificationVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEmailVerificationID];
            [self.loginActivityIndicator stopAnimating];
            [self.navigationController pushViewController:emailVerificationVC animated:YES];
        } else {
            [self.loginActivityIndicator stopAnimating];
        }
    });
}

- (void)userFacebookLoginData
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            if (facebookID)
            {
                [[PFUser currentUser] setObject:facebookID forKey:kStringrUserFacebookIDKey];
            }
        
            if (userData[@"name"])
            {
                [[PFUser currentUser] setObject:userData[@"name"] forKey:kStringrUserDisplayNameKey];
            }
            
            if ([pictureURL absoluteString])
            {
                [[PFUser currentUser] setObject:[pictureURL absoluteString] forKey:kStringrUserProfilePictureURLKey];
                [self downloadProfileImage];
            }
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"])
        {
            NSLog(@"The facebook session was invalidated");
        } else
        {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

- (void)userTwitterLoginData
{
    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];

    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (userData) {
        
        NSString *twitterID = [userData objectForKey:@"id"];
        if (twitterID) {
            [[PFUser currentUser] setObject:twitterID forKey:kStringrUserTwitterIDKey];
        }
        
        NSString *displayName = [userData objectForKey:@"name"];
        if (displayName) {
            [[PFUser currentUser] setObject:displayName forKey:kStringrUserDisplayNameKey];
        }
        
        //NSString *description = [userData objectForKey:@"description"];
        NSString *profileImageURL = [userData objectForKey:@"profile_image_url"];
        if (profileImageURL) {
            profileImageURL = [profileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            [[PFUser currentUser] setObject:profileImageURL forKey:kStringrUserProfilePictureURLKey];
            [self downloadProfileImage];
        }
        
        NSString *screenName = [userData objectForKey:@"screen_name"];
        if (screenName) {
            // saves the case sensitive version of the username
            [[PFUser currentUser] setObject:screenName forKey:kStringrUserUsernameCaseSensitive];
            
            // saves the case insensitive version of the username
            screenName = [screenName lowercaseString];
            [[PFUser currentUser] setObject:screenName forKey:kStringrUserUsernameKey];
        }
        
        [[PFUser currentUser] setObject:@"Edit your profile to set the description." forKey:kStringrUserDescriptionKey];
        [[PFUser currentUser] setObject:@(0) forKey:kStringrUserNumberOfStringsKey];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.delegate socialNetworkProfileImageDidFinishDownloading:self.userProfileImage];
            }
        }];
    }
    
}

- (void)downloadProfileImage
{
    // Download the user's social network profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:kStringrUserFacebookIDKey] && [[PFUser currentUser] objectForKey:kStringrUserProfilePictureURLKey]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:kStringrUserProfilePictureURLKey]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    } else if ([[PFUser currentUser] objectForKey:kStringrUserTwitterIDKey] && [[PFUser currentUser] objectForKey:kStringrUserProfilePictureURLKey]) {
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

- (void)setupBlurredUsernameAndPasswordBackgrounds
{
    self.usernameBlurredView.translucentAlpha = 0.9;
    self.usernameBlurredView.translucentStyle = UIBarStyleDefault;
    self.usernameBlurredView.translucentTintColor = [UIColor clearColor];
    self.usernameBlurredView.backgroundColor = [UIColor clearColor];
    
    self.passwordBlurredView.translucentAlpha = 0.9;
    self.passwordBlurredView.translucentStyle = UIBarStyleDefault;
    self.passwordBlurredView.translucentTintColor = [UIColor clearColor];
    self.passwordBlurredView.backgroundColor = [UIColor clearColor];
}

- (void)setupTextFieldDesign
{
    NSAttributedString *attributedUsernameString = [[NSAttributedString alloc] initWithString:@"Username..." attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    [self.usernameTextField setAttributedPlaceholder:attributedUsernameString];
    
    NSAttributedString *attributedPasswordString = [[NSAttributedString alloc] initWithString:@"Password..." attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    [self.passwordTextField setAttributedPlaceholder:attributedPasswordString];
}

- (void)handleUserLogin:(PFUser *)user withError:(NSError *)error
{
    [self.loginActivityIndicator stopAnimating];
    
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        //[self presentCheckYourInternetConnectionAlertView];
        return;
    }
    
    if (error.code == 101) { // 101 = invalid login credentials
        // The login failed. Check error to see why.
        UIAlertView *invalidLoginCredentials = [[UIAlertView alloc] initWithTitle:@"Unable to Login" message:@"We cannot log you in with that username and password combination!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [invalidLoginCredentials show];
    }
    else if (error.code == 201) { // 201 = no password entered
        UIAlertView *noPasswordEntered = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"Please enter your password!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noPasswordEntered show];
    }
    else if ( [StringrUtility usernameUserCanLogin:user] || [StringrUtility facebookUserCanLogin:user] || [StringrUtility twitterUserCanLogin:user] ) {
        // instantiates the main logged in content area
//        [(StringrAppDelegate *)[[UIApplication sharedApplication] delegate] setupLoggedInContent];
        
        //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self dismissViewControllerAnimated:YES completion:^ {
            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                if (!error) {
                    [[PFUser currentUser] setObject:geoPoint forKey:@"geoLocation"];
                    
                    // Saves the user after we have ensured they are a valid college student
                    [[PFUser currentUser] saveInBackground];
                }
            }];
        }];
        
        // alert delegate that we logged in with user
        [self.delegate logInViewController:self didLogInUser:[PFUser currentUser]];
    }
    else if ([StringrUtility usernameUserNeedsToVerifyEmail:user]) {
        [self.userNeedsToVerifyEmailButton setHidden:NO];
        StringrEmailVerificationViewController *emailVerificationVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEmailVerificationID];
        [self.navigationController pushViewController:emailVerificationVC animated:YES];
    }
}

- (void)presentCheckYourInternetConnectionAlertView
{
    UIAlertView *checkInternetConnectionAlertView = [[UIAlertView alloc] initWithTitle:@"Check Your Connection" message:@"There seems to be something wrong with your connection! Make sure that you're connected to the internet or just try again soon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [checkInternetConnectionAlertView show];
}



#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.userProfileImage = [UIImage imageWithData:self.profileImageData];
    UIImage *thumbnailProfileImage = [self.userProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    
    NSData *profileThumbnailImageData = UIImagePNGRepresentation(thumbnailProfileImage);
    
    // Saves the users Facebook profile image as a parse file once the data has been loaded
    PFFile *profileImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"profileImage.png"] data:self.profileImageData];
    PFFile *profileThumbnailImageFile = [PFFile fileWithName:@"profileThumbnailImage.png" data:profileThumbnailImageData];
    
    [profileImageFile saveInBackground];
    [profileThumbnailImageFile saveInBackground];
    
    [[PFUser currentUser] setObject:profileImageFile forKey:kStringrUserProfilePictureKey];
    [[PFUser currentUser] setObject:profileThumbnailImageFile forKey:kStringrUserProfilePictureThumbnailKey];
    // Save with block so that the menu profile image is not called until the new image has finished uploading
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.delegate socialNetworkProfileImageDidFinishDownloading:self.userProfileImage];
        }
    }];
}



#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        if ([StringrUtility NSStringIsValidUsername:textField.text]) {
            self.username = self.usernameTextField.text;
            self.username = [self.username lowercaseString];
        }
    } else if (textField == self.passwordTextField) {
        if (self.passwordTextField.text.length != 0) {
            self.userPassword = self.passwordTextField.text;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Selects the password field if you return on the username
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        
        [self.loginActivityIndicator startAnimating];
        [PFUser logInWithUsernameInBackground:self.username
                                     password:self.userPassword
                                       target:self
                                     selector:@selector(handleUserLogin:withError:)];
    }
    
    return YES;
}



@end
