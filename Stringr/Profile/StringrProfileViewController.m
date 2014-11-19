//
//  StringrProfileViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileViewController.h"
#import "StringrUtility.h"
#import "StringrPathImageView.h"
#import "StringrEditProfileViewController.h"
#import "StringrProfileTopViewController.h"
#import "StringrProfileTableViewController.h"
#import "StringrStringDetailViewController.h"
#import "UIColor+StringrColors.h"
#import "UIDevice+StringrAdditions.h"
#import "StringrFollowingTableViewController.h"

static NSString * const StringrProfileStoryboardName = @"StringrProfileStoryboard";

/**
 * Initialize's a user profile as a parallax view controller. The top half is a users information and
 * the bottom is a tableView of their String's. You must provide a user for the profile in order for it to work
 * as well as a profileReturnState. The return state refers to how the profile is being displayed: From the menu,
 * as a modal presentation, or just pushed onto a nav controller. The return state provides information on what return
 * navigation item will be displayed.
 */
@interface StringrProfileViewController () <StringrEditProfileDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) StringrProfileTopViewController *topProfileVC;
@property (strong, nonatomic) StringrProfileTableViewController *tableProfileVC;

@end

@implementation StringrProfileViewController

#pragma mark - Lifecycle

+ (StringrProfileViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrProfileStoryboardName bundle:nil];
    
    return (StringrProfileViewController *)[storyboard instantiateInitialViewController];
}

- (void)dealloc
{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    // Guarantee's that if the passed in user is the current user we provide the ability to edit that profile
    if ([self.userForProfile.username isEqualToString:[[PFUser currentUser] username]]) {
        self.title = @"My Profile";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(pushToEditProfile)];
    }
    
    // Sets the 'return' button based off of what state the profile is in. Modal, Menu, or Back.
    if (self.profileReturnState == ProfileModalReturnState) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeProfileVC)];
    } else if (self.profileReturnState == ProfileMenuReturnState) {
        // Creates the navigation item to access the menu
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                 style:UIBarButtonItemStyleDone target:self
                                                                                action:@selector(showMenu)];
    } else if (self.profileReturnState == ProfileBackReturnState) {
        
    }
    /*
    // Instantiates the parallax VC with a top and bottom VC.
    self.topProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileTopViewID];
    
    [self.topProfileVC setUserForProfile:self.userForProfile];
    
    self.tableProfileVC = [[StringrProfileTableViewController alloc] initWithUser:self.userForProfile];
    
    CGFloat topHeight = 231.0f;
    
    if ([[UIDevice currentDevice] isAtLeastiOS8]) {
        topHeight += 64.0f;
    }
    
    [self setupWithTopViewController:self.topProfileVC andTopHeight:345.0f andBottomViewController:self.tableProfileVC];
    
    //self.delegate = self; // prevents deallocation
    self.maxHeightBorder = CGRectGetHeight(self.view.frame);
    [self enableTapGestureTopView:NO];
    */
     
    [self.view setBackgroundColor:[UIColor stringrLightGrayColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Private

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}



#pragma mark - Actions

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

- (void)pushToEditProfile
{
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEditProfileID];
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    [editProfileVC setFillerProfileImage:topVC.profileImage];
    [editProfileVC setFillerProfileName:[self.userForProfile objectForKey:kStringrUserDisplayNameKey]];
    [editProfileVC setFillerDescription:topVC.profileDescriptionLabel.text];
    
    [editProfileVC setDelegate:self];
    
    [self.navigationController pushViewController:editProfileVC animated:YES];
}



#pragma mark - StringrEditProfile Delegate

- (void)setProfilePhoto:(UIImage *)profilePhoto
{
    [self.topProfileVC.profileImage setImage:profilePhoto];
}

- (void)setProfileName:(NSString *)name
{
    self.topProfileVC.profileNameLabel.text = name;
}

- (void)setProfileDescription:(NSString *)description
{
    self.topProfileVC.profileDescriptionLabel.text = description;
}



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:newStringVC animated:YES];
    } else if (buttonIndex == 1) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
}



#pragma mark - Parallax Delegate Methods

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state
{
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeTopHeight:(CGFloat)height
{
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeGesture:(QMBParallaxGesture)newGesture oldGesture:(QMBParallaxGesture)oldGesture
{
    
}


@end
