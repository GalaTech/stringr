//
//  StringrLoginViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrLoginViewController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrRootViewController.h"

#import "StringrProfileViewController.h"



@interface StringrLoginViewController () <UIAlertViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property int imageNumber;
@property (strong, nonatomic) NSTimer *backgroundRotationTimer;
@property (strong, nonatomic) NSMutableArray *universityNames;
@property (strong, nonatomic) NSMutableData *profileImageData;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *facebookLoginActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation StringrLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.facebookLoginActivityIndicator startAnimating];
    
    // prevents a user from tapping the login button before it checks to see if you're already connected
    [self.facebookLoginButton setUserInteractionEnabled:NO];
    
    // delay time for check so that there is not a error with the navigation
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.facebookLoginActivityIndicator stopAnimating];
        [self.facebookLoginButton setUserInteractionEnabled:YES];
        
        // Check if user is cached and linked to Facebook, if so, bypass login
        if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            //[self userLoginData];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
    
    // Disables the menu from being able to be pulled out via gesture
    //self.frostedViewController.panGestureEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    self.imageNumber = 2;
    
    NSTimeInterval time = 10.0;
    self.backgroundRotationTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(changeBackgroundImage) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.backgroundRotationTimer invalidate];
    
    //self.frostedViewController.panGestureEnabled = YES;
}





#pragma mark - IBActions

- (IBAction)loginWithFacebookButtonTouchHandler:(UIButton *)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_location", @"user_education_history", @"user_groups"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // Hide loading indicator
        [self.facebookLoginActivityIndicator stopAnimating];
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                //[alert show];
            }
            /*
            else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
             */
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
            [self userLoginData];
        } else {
            NSLog(@"User with facebook logged in!");
            
            [self userLoginData];
        }
    }];
    
    // Show loading indicator until login is finished
    [self.facebookLoginActivityIndicator startAnimating];
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




#pragma mark - Private

- (void)userLoginData
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            //NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                [[PFUser currentUser] setObject:facebookID forKey:@"facebookProfileID"];
                //userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                [[PFUser currentUser] setObject:userData[@"name"] forKey:@"displayName"];
                //userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                [[PFUser currentUser] setObject:userData[@"location"][@"name"] forKey:@"userLocation"];
                //userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if ([pictureURL absoluteString]) {
                [[PFUser currentUser] setObject:[pictureURL absoluteString] forKey:@"facebookProfilePictureURL"];
                [self downloadFacebookProfileImage];
                //userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            if ([self didAttendCollege:userData]) {
                NSLog(@"YES! They are a college student!");
                
                [[PFUser currentUser] setObject:@(YES) forKey:@"isCollegeStudent"];
                [[PFUser currentUser] setObject:self.universityNames forKey:@"userUniversityNames"];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"not a college student...");
                
                // not needed because we log the user out and return before the info is saved.
                //[[PFUser currentUser] setObject:@(NO) forKey:@"isCollegeStudent"];
                
                UIAlertView *notACollegeStudent = [[UIAlertView alloc] initWithTitle:@"Unable to Login" message:@"You must be a college student to login!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [notACollegeStudent show];
                
                // Logs the user out so that they can attempt in the future. Otherwise it will always attempt
                // a login on the initial account that was entered.
                [PFUser logOut];
                return;
            }
            
            //[[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            
            // Saves the user after we have ensured they are a valid college student
            [[PFUser currentUser] saveInBackground];
            
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"]) {
            
            // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}

// Fast enumerates through the data of the users Facebook info.
// It checks all of their college info to see if they attended a
// college.
- (BOOL)didAttendCollege:(NSDictionary *)userData
{
    self.universityNames = [[NSMutableArray alloc] init];
    
    for (FBGraphObject *educationObject in userData[@"education"]) {
        NSString *educationType = educationObject[@"type"];
        
        if ([educationType isEqualToString:@"College"]) {
            NSString *universityName = educationObject[@"school"][@"name"];
            [self.universityNames addObject:universityName];
            
        }
    }
    
    return self.universityNames.count > 0;
}

- (void)downloadFacebookProfileImage
{
    // Download the user's facebook profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"facebookProfilePictureURL"]];
        
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





#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}




#pragma mark - NSURLConnectionDataDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[PFUser currentUser] setObject:self.profileImageData forKey:@"userProfileImageData"];
    [[PFUser currentUser] saveInBackground];
}





@end
