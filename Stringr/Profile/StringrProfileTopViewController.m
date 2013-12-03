//
//  StringrProfileTopViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileTopViewController.h"
#import "StringrProfileViewController.h"

#import "GBPathImageView.h"

@interface StringrProfileTopViewController ()

@property (weak, nonatomic) IBOutlet GBPathImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *profileDescriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileUniversityLabel;

@end

@implementation StringrProfileTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    // Adds the circular path to the profile image
    [self.profileImage setPathType:GBPathImageViewTypeCircle];
    [self.profileImage setPathWidth:1.1];
    [self.profileImage setPathColor:[UIColor darkGrayColor]];
    [self.profileImage setBorderColor:[UIColor darkGrayColor]];
    [self.profileImage draw];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        
        //float r = (parallaxController.topViewControllerStandartHeight * 1.25f) / newHeight;
        
       // [self.gradientImageView setAlpha:r*r];
        
    } else {
        
        float r = newHeight / parallaxController.topViewControllerStandartHeight;
        
        [self.profileImage setAlpha:r];
        [self.profileNameLabel setAlpha:r];
        [self.profileDescriptionTextView setAlpha:r];
        [self.profileNumberOfStringsLabel setAlpha:r*r];
        [self.profileUniversityLabel setAlpha:r*r*r*r];
        //[self.gradientImageView setAlpha:r*r*r*r];
        
        
    }
    
}

@end
