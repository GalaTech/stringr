//
//  StringrProfileTopViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTopViewController.h"
#import "StringrProfileViewController.h"
#import "StringrEditProfileViewController.h"
#import "StringrUserTableViewController.h"


@interface StringrProfileTopViewController ()

@end

@implementation StringrProfileTopViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    self.view = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.profileNameLabel setText:[self.userForProfile objectForKey:kStringrUserDisplayNameKey]];
    //[self.profileUniversityLabel setText:[NSString stringWithFormat:@"@%@", [self.userForProfile objectForKey:kStringrUserSelectedUniversityKey]]];
    [self.profileDescriptionLabel setText:[self.userForProfile objectForKey:kStringrUserDescriptionKey]];
    
    int numberOfStrings = [[self.userForProfile objectForKey:kStringrUserNumberOfStringsKey] intValue];
    
    NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", numberOfStrings];
    if (numberOfStrings == 1) {
        numberOfStringsText = [NSString stringWithFormat:@"%d String", numberOfStrings];
    }
    
    [self.profileNumberOfStringsLabel setText:numberOfStringsText];
    
    
    
    
    
    // Sets the circle image path properties
    
    [self.profileImage setImage:[UIImage imageNamed:@"Stringr Image"]];
    [self.profileImage setFile:[self.userForProfile objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImage loadInBackground];
    
    [self.profileImage setImageToCirclePath];
    [self.profileImage setPathWidth:1.0];
    [self.profileImage setPathColor:[UIColor darkGrayColor]];
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    /*
    PFFile *userProfileImageFile = [self.userForProfile objectForKey:kStringrUserProfilePictureKey];
    [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            [self.profileImage setImage:profileImage];
        }
    }];
     */
    

    
    // Adds custom design to follow user button
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    self.followUserButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    
    
    
    // Sets the title of the button to follow or unfollow depending upon what the users
    // relationship is with the current profile.
    if (!self.isFollowingUser) {
        [self.followUserButton setTitle:@"Follow" forState:UIControlStateNormal];
    } else {
        [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



#pragma mark - Public

/** Allows you to change the values of objects in the top view controller when a user begins to
 * scroll. It calculates changes based on the old height and new height of the top view controller
 * I utilize this for changing the alpha value when a user scrolls up on the parallax view. That way
 * it will decrease objects alpha value until they are transparent.
 *
 * @param oldHeight The old/previous height of the top view controller
 * @param newHeight The new height of the top view controller.
 */
- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    /*
     if (newHeight >= parallaxController.topViewControllerStandartHeight) {
     
     
     [self.profileImage setAlpha:1];
     [self.profileNameLabel setAlpha:1];
     [self.profileDescriptionLabel setAlpha:1];
     [self.profileNumberOfStringsLabel setAlpha:1];
     [self.profileUniversityLabel setAlpha:1];
     [self.followUserButton setAlpha:1];
     
     //float r = (parallaxController.topViewControllerStandartHeight * 1.25f) / newHeight;
     // [self.gradientImageView setAlpha:r*r];
     
     } else {
     
     float r = newHeight / parallaxController.topViewControllerStandartHeight;
     
     [self.profileImage setAlpha:r];
     [self.profileNameLabel setAlpha:r];
     [self.followingButton setAlpha:r];
     [self.followingLabel setAlpha:r];
     [self.followersButton setAlpha:r];
     [self.followersLabel setAlpha:r];
     [self.profileDescriptionLabel setAlpha:r];
     [self.profileNumberOfStringsLabel setAlpha:r*r];
     [self.profileUniversityLabel setAlpha:r*r*r*r];
     [self.followUserButton setAlpha:r*r*r*r];
     }
     */
    
}




#pragma mark - IBActions

- (IBAction)followUserButton:(UIButton *)sender
{
    if (!self.isFollowingUser) {
        UIAlertView *followAlert = [[UIAlertView alloc] initWithTitle:@"Followed"
                                                        message:[NSString stringWithFormat:@"You are now following %@!", self.profileNameLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        
        [followAlert show];
        
        [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.followUserButton setStyle:[StringrConstants kStringTableViewBackgroundColor] andBottomColor:[StringrConstants kStringCollectionViewBackgroundColor]];
        [self.followUserButton setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor lightTextColor] disableColor:nil];
        [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
        [self.followUserButton setCornerRadius:15];
        [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
        self.followUserButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    } else {
        UIAlertView *unfollowAlert = [[UIAlertView alloc] initWithTitle:@"Unfollowed"
                                                        message:[NSString stringWithFormat:@"You are no longer following %@.", self.profileNameLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        
        [unfollowAlert show];
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[StringrConstants kStringTableViewBackgroundColor]];
        [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
        [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
        [self.followUserButton setCornerRadius:15];
        [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
        self.followUserButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    }
    
    self.isFollowingUser = !self.isFollowingUser;
     
}

- (IBAction)accessFollowers:(UIButton *)sender
{
    StringrUserTableViewController *followersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersVC"];
    
    
    PFQuery *followersQuery = [PFUser query];
    [followersQuery orderByAscending:@"displayName"];
    [followersQuery whereKey:kStringrUserDisplayNameKey notEqualTo:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
    [followersVC setQueryForTable:followersQuery];
    
    [followersVC setTitle:@"Followers"];
    
    
    [self.navigationController pushViewController:followersVC animated:YES];
}


- (IBAction)accessFollowing:(UIButton *)sender
{
    StringrUserTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingVC"];
    
    PFQuery *followingQuery = [PFUser query];
    [followingQuery orderByAscending:@"displayName"];
    [followingQuery whereKey:kStringrUserDisplayNameKey notEqualTo:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
    [followingVC setQueryForTable:followingQuery];
    
    [followingVC setTitle:@"Following"];
    
    
    [self.navigationController pushViewController:followingVC animated:YES];
}




 

@end
