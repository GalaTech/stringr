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

@interface StringrProfileViewController ()

@property (strong, nonatomic) NSTimer *tapTimer;

@end

@implementation StringrProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // If the user is not supposed to be able to go back then we init with the menu item
    if (!self.canGoBack) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(showMenu)];
    }
    
    // Displays the ability to edit profile in the nav bar if available
    if (self.canEditProfile) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(beginEditingProfile)];
    }
    
    
    // Instantiates the parallax VC with a top and bottom VC.
    UIViewController *topProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopProfileVC"];
    UITableViewController *tableProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableProfileVC"];
    
    [self setupWithTopViewController:topProfileVC height:265 tableViewController:tableProfileVC];
    
    
    
    // Adds tap gesture to the view for use with tapping controls in the topVC
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
    
}

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
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









#pragma mark - Edit Profile
- (void)beginEditingProfile
{
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    UILabel *nameLabel = topVC.profileNameLabel;
    [nameLabel setText:@"New Name"];
    
    /*
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:editProfileVC animated:YES];
     */
}




#pragma mark - Parallax Methods

- (void)willChangeHeightOfTopViewControllerFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    StringrProfileTopViewController * topViewController = (StringrProfileTopViewController *)self.topViewController;
    [topViewController willChangeHeightFromHeight:oldHeight toHeight:newHeight];
    
    float r = (self.topViewControllerStandartHeight * 1.5f) / newHeight;
    [self.tableViewController.view setAlpha:r*r*r*r*r*r];
    
}


@end
