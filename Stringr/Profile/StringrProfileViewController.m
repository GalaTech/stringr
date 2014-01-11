//
//  StringrProfileViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileViewController.h"
#import "StringrUtility.h"

#import "StringrEditProfileViewController.h"
#import "StringrProfileTopViewController.h"

@interface StringrProfileViewController () <StringrEditProfileDelegate>


@end

@implementation StringrProfileViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // If the user is not supposed to be able to go back then we init with the menu item
    if (self.canGoBack) {
        
    }
    
    
    
    if (self.canCloseModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonSystemItemCancel target:self action:@selector(closeProfileVC)];
    }
    
    
    
    // Displays the ability to edit profile in the nav bar if available
    if (self.canEditProfile) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(pushToEditProfile)];
        // Creates the navigation item to access the menu
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                 style:UIBarButtonItemStyleDone target:self
                                                                                action:@selector(showMenu)];
    }
    
    
    // Instantiates the parallax VC with a top and bottom VC.
    UIViewController *topProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopProfileVC"];
    UITableViewController *tableProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableProfileVC"];
    
    [self setupWithTopViewController:topProfileVC height:265 tableViewController:tableProfileVC];
   
    
    // Sets the background color of the table view correctly, but overlaps the topVC
//    UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    [tableProfileVC.tableView setBackgroundColor:veryLightGrayColor];
    
    
    
    // Adds tap gesture to the view for use with tapping controls in the topVC
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
    // Dynamically sets the number of strings label to how many strings are in the table view
    NSString *numberOfStrings = [NSString stringWithFormat:@"%ld Strings", (long)self.tableViewController.tableView.numberOfSections];
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    topVC.profileNumberOfStringsLabel.text = numberOfStrings;
}

#pragma mark - Utility

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}


- (void)closeProfileVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Gesture Recognizer Methods and Delegate

- (void)handleTapGesture:(id)sender
{
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Yup" message:@"You pressed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    */
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tapPoint = [touch locationInView:self.view];
    
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    if ([topVC.view hitTest:tapPoint withEvent:nil]) {
        tapPoint = [touch locationInView:topVC.followUserButton];
        
        
        if ([topVC.followUserButton hitTest:tapPoint withEvent:nil ]) {
            
            [topVC.followUserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            return YES;
        }
        
        tapPoint = [touch locationInView:topVC.followingFollowersButton];
        if ([topVC.followingFollowersButton hitTest:tapPoint withEvent:nil]) {
            
            [topVC.followingFollowersButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            return YES;
        }
    }
    
    return NO;
}
 




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint tapPoint = [touch locationInView:self.view];
    
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    if ([topVC.view hitTest:tapPoint withEvent:nil]) {
        tapPoint = [touch locationInView:topVC.followUserButton];
        
        if ([topVC.followUserButton hitTest:tapPoint withEvent:nil ]) {
            
            
            [topVC.followUserButton setHighlighted:YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Test");
    UITouch *touch = [touches anyObject];
    
    CGPoint tapPoint = [touch locationInView:self.view];
    
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    if ([topVC.view hitTest:tapPoint withEvent:nil]) {
        tapPoint = [touch locationInView:topVC.followUserButton];
        if ([topVC.followUserButton hitTest:tapPoint withEvent:nil ]) {
            
            [topVC.followUserButton setHighlighted:YES];
        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Test");
    UITouch *touch = [touches anyObject];
    
    CGPoint tapPoint = [touch locationInView:self.view];
    
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    if ([topVC.view hitTest:tapPoint withEvent:nil]) {
        tapPoint = [touch locationInView:topVC.followUserButton];
        if ([topVC.followUserButton hitTest:tapPoint withEvent:nil ]) {
            
            [topVC.followUserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [topVC.followUserButton setHighlighted:NO];
        }
    
    }
}









#pragma mark - Push new page onto Navigation
- (void)pushToEditProfile
{
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    [editProfileVC setFillerProfileImage:topVC.profileImage];
    [editProfileVC setFillerProfileName:topVC.profileNameLabel.text];
    [editProfileVC setFillerDescription:topVC.profileDescriptionLabel.text];
    
    [editProfileVC setDelegate:self];
    
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:editProfileVC animated:YES];
}



#pragma mark - StringrEditProfile Delegate

- (void)setProfileImage:(StringrPathImageView *)profileImage
{
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    
    topViewController.profileImage = profileImage;
}

- (void)setProfileName:(NSString *)name
{
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    
    topViewController.profileNameLabel.text = name;
}

- (void)setProfileDescription:(NSString *)description
{
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    
    //UIFont *currentTextViewFont = topViewController.profileDescriptionTextView.font;
    //UITextAlignment *currentTextViewAlignment = topViewController.profileDescriptionTextView.textAlignment;
    //UIColor *currentTextViewColor = topViewController.profileDescriptionTextView.textColor;
    
    topViewController.profileDescriptionLabel.text = description;
    
    //[topViewController.profileDescriptionTextView setFont:currentTextViewFont];
    //[topViewController.profileDescriptionTextView setTextAlignment:currentTextViewAlignment];
    //[topViewController.profileDescriptionTextView setTextColor:currentTextViewColor];
}




#pragma mark - Parallax Methods

- (void)willChangeHeightOfTopViewControllerFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    [topViewController willChangeHeightFromHeight:oldHeight toHeight:newHeight];
    
    float r = (self.topViewControllerStandartHeight * 1.5f) / newHeight;
    [self.tableViewController.view setAlpha:r*r*r*r*r*r];
    
}


@end
