//
//  StringrEmailVerificationViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrEmailVerificationViewController.h"
#import "StringrPathImageView.h"
#import "ACPButton.h"
#import "StringrAppViewController.h"
#import "StringrAppDelegate.h"
#import "UIColor+StringrColors.h"
#import "StringrColoredView.h"

@interface StringrEmailVerificationViewController ()

@property (weak, nonatomic) IBOutlet StringrPathImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet ACPButton *checkAgainButton;
@property (weak, nonatomic) IBOutlet UILabel *verifedLabel;

@end

@implementation StringrEmailVerificationViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Email Verification";
    
    [self.view addSubview:[StringrColoredView defaultColoredView]];
    
    // load profile image from property or user info
    if (self.userProfileImage) {
        [self.userProfileImageView setImage:self.userProfileImage];
    } else {
        PFFile *userProfileImage = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureThumbnailKey];
        [self.userProfileImageView setFile:userProfileImage];
        [self.userProfileImageView loadInBackgroundWithIndicator];
    }
    
    [self.userProfileImageView setImageToCirclePath];
    [self.userProfileImageView setPathColor:[UIColor lightGrayColor]];
    [self.userProfileImageView setPathWidth:1.0f];
    
    // Adds custom design to follow user button
    [self.checkAgainButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor stringrLightGrayColor]];
    [self.checkAgainButton setLabelTextColor:[UIColor grayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.checkAgainButton setCornerRadius:15];
    [self.checkAgainButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    self.checkAgainButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - IBAction's

- (IBAction)checkAgainButtonTouchHandler:(UIButton *)sender
{
    // checks to see if the user has verified their email
    if ([PFUser currentUser]) {
        [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                if ([[user objectForKey:kStringrUserEmailVerifiedKey] boolValue] == YES) {
                    [self.verifedLabel setText:@"Verified"];
                    [self.verifedLabel setTextColor:[UIColor greenColor]];
                    
                    [[UIApplication appDelegate].appViewController transitionToDashboardViewController:YES];
                    
//                    [self dismissViewControllerAnimated:YES completion:^ {
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
//                    }];
                }
            }
        }];
    }
}


@end
