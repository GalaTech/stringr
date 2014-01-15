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
#import "StringrFollowingFollowersTabBarViewController.h"
#import "StringrUserTableViewController.h"


@interface StringrProfileTopViewController ()

@end

@implementation StringrProfileTopViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.profileNameLabel.text;
	
    // Sets the circle image path properties
    [self.profileImage setImageToCirclePath];
    //[self.profileImage setImage:self.profileImage.image];
    [self.profileImage setPathWidth:1.0];
    [self.profileImage setPathColor:[UIColor darkGrayColor]];
    
    
    UIColor *veryLightGrayColor = [UIColor colorWithWhite:.90 alpha:1.0];
    
    // Adds custom design to follow user button
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:veryLightGrayColor];
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
}





#pragma mark - UIControls


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
    } else {
        UIAlertView *unfollowAlert = [[UIAlertView alloc] initWithTitle:@"Unfollowed"
                                                        message:[NSString stringWithFormat:@"You are no longer following %@.", self.profileNameLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        
        [unfollowAlert show];
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
    }
    
    self.isFollowingUser = !self.isFollowingUser;
     
}

- (IBAction)accessFollowers:(UIButton *)sender
{
    StringrUserTableViewController *followersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersVC"];
    [followersVC setTitle:@"Followers"];
    
    
    [self.navigationController pushViewController:followersVC animated:YES];
}


- (IBAction)accessFollowing:(UIButton *)sender
{
    StringrUserTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingVC"];
    [followingVC setTitle:@"Following"];
    
    
    [self.navigationController pushViewController:followingVC animated:YES];
}



#pragma mark - Parallax Controller Method

/** Allows you to change the values of objects in the top view controller when a user begins to 
 * scroll. It calculates changes based on the old height and new height of the top view controller
 * I utilize this for changing the alpha value when a user scrolls up on the parallax view. That way
 * it will decrease objects alpha value until they are transparent.
 *
 * @param oldHeight The old/previous height of the top view controller
 * @param newHeight The new height of the top view controller.
 */
- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    M6ParallaxController * parallaxController = [self parallaxController];
    
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
    
}

@end
