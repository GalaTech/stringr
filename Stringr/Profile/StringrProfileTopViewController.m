//
//  StringrProfileTopViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTopViewController.h"
#import "StringrProfileViewController.h"


@interface StringrProfileTopViewController ()


@end

@implementation StringrProfileTopViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    // Adds the circular path to the profile image
    [self.profileImage setPathType:GBPathImageViewTypeCircle];
    [self.profileImage setPathWidth:1.1];
    [self.profileImage setPathColor:[UIColor darkGrayColor]];
    [self.profileImage setBorderColor:[UIColor darkGrayColor]];
    [self.profileImage draw];
    
    
    UIColor *veryLightGrayColor = [UIColor colorWithWhite:.90 alpha:1.0];
    
    // Adds custom design to follow user button
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:veryLightGrayColor];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    self.followUserButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    
}



- (IBAction)followUserButton:(UIButton *)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Followed"
                                                    message:@"You are now following Alonso Holmes!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    
    [alert show];
     
}




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
        [self.profileDescriptionTextView setAlpha:1];
        [self.profileNumberOfStringsLabel setAlpha:1];
        [self.profileUniversityLabel setAlpha:1];
        [self.followUserButton setAlpha:1];
        
        //float r = (parallaxController.topViewControllerStandartHeight * 1.25f) / newHeight;
        
       // [self.gradientImageView setAlpha:r*r];
        
    } else {
        
        float r = newHeight / parallaxController.topViewControllerStandartHeight;
        
        [self.profileImage setAlpha:r];
        [self.profileNameLabel setAlpha:r];
        [self.profileDescriptionTextView setAlpha:r];
        [self.profileNumberOfStringsLabel setAlpha:r*r];
        [self.profileUniversityLabel setAlpha:r*r*r*r];
        [self.followUserButton setAlpha:r*r*r*r];
        //[self.gradientImageView setAlpha:r*r*r*r];
        
        
    }
    
}

@end
