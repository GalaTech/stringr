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
#import "StringrProfileTableViewController.h"
#import "StringrStringEditViewController.h"

@interface StringrProfileViewController () <StringrEditProfileDelegate, UIActionSheetDelegate>


@end

@implementation StringrProfileViewController

#pragma mark - Initialization


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:@"UploadNewString" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Instantiates the parallax VC with a top and bottom VC.
    StringrProfileTopViewController *topProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopProfileVC"];
    StringrProfileTableViewController *tableProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableProfileVC"];
    
    [self setupWithTopViewController:topProfileVC andTopHeight:325 andBottomViewController:tableProfileVC];
    self.delegate = self;
    
    self.maxHeightBorder = self.view.frame.size.height;
    [self enableTapGestureTopView:NO];
    
    //[self setupWithTopViewController:topProfileVC height:265 tableViewController:tableProfileVC];
    
    
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
    
    
    // Sets the background color of the table view correctly, but overlaps the topVC
//    UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    [tableProfileVC.tableView setBackgroundColor:veryLightGrayColor];
    
    
    /*
    // Adds tap gesture to the view for use with tapping controls in the topVC
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    */
    
    
    // Dynamically sets the number of strings label to how many strings are in the table view
    
    StringrProfileTableViewController *testTableVC = (StringrProfileTableViewController *)self.bottomViewController;
    NSString *numberOfStrings = [NSString stringWithFormat:@"%ld Strings", (long)testTableVC.tableView.numberOfSections];
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


- (void)addNewString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Create New String"
                                                                      delegate:self
                                                             cancelButtonTitle:@"cancel"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"Take Photo", @"Choose From Existing", nil];
    
    [newStringActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        StringrStringEditViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    } else if (buttonIndex == 1) {
        
        
        StringrStringEditViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    }
}




#pragma mark - Gesture Recognizer Methods and Delegate

- (void)handleTapGesture:(id)sender
{
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Yup" message:@"You pressed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    */
}
/*

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
        
        tapPoint = [touch locationInView:topVC.followersButton];
        if ([topVC.followersButton hitTest:tapPoint withEvent:nil]) {
            
            [topVC.followersButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            return YES;
        }
        
        
        tapPoint = [touch locationInView:topVC.followingButton];
        if ([topVC.followingButton hitTest:tapPoint withEvent:nil]) {
            
            [topVC.followingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            return YES;
        }
    }
    
    return NO;
}
 

*/

/*
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
 */

/*
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
 */

/*
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
 */









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




#pragma mark - Parallax Delegate Methods

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state
{
    
    NSLog(@"didChangeState %d",state);
    //[self.navigationController setNavigationBarHidden:self.state == QMBParallaxStateFullSize animated:YES];
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeTopHeight:(CGFloat)height
{
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeGesture:(QMBParallaxGesture)newGesture oldGesture:(QMBParallaxGesture)oldGesture
{
    
}


/*
- (void)willChangeHeightOfTopViewControllerFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    [topViewController willChangeHeightFromHeight:oldHeight toHeight:newHeight];
    
    float r = (self.topViewControllerStandartHeight * 1.5f) / newHeight;
    [self.tableViewController.view setAlpha:r*r*r*r*r*r];
    
}
 */


@end
