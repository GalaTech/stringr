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
#import "StringrStringDetailViewController.h"


@interface StringrProfileViewController () <StringrEditProfileDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) StringrProfileTopViewController *topProfileVC;
@property (strong, nonatomic) StringrProfileTableViewController *tableProfileVC;

@end

@implementation StringrProfileViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    self.view = nil;
    //self.tableProfileVC = nil;
    //self.topProfileVC = nil;
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
    // Instantiates the parallax VC with a top and bottom VC.
    self.topProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopProfileVC"];
    // Sets the user for the currently accessed profile
    [self.topProfileVC setUserForProfile:self.userForProfile];
    
    self.tableProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableProfileVC"];
    
    // Querries all strings that are owned by the user for the specified profile
    PFQuery *profileStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [profileStringsQuery whereKey:kStringrStringUserKey equalTo:self.userForProfile];
    [profileStringsQuery orderByAscending:@"createdAt"];
    [self.tableProfileVC setQueryForTable:profileStringsQuery];
    
    [self setupWithTopViewController:self.topProfileVC andTopHeight:325 andBottomViewController:self.tableProfileVC];
    
    self.delegate = self;
    self.maxHeightBorder = CGRectGetHeight(self.view.frame);
    [self enableTapGestureTopView:NO];
    
    [self.view setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:@"UploadNewString" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadNewString" object:nil];
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
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    [editProfileVC setFillerProfileImage:topVC.profileImage];
    [editProfileVC setFillerProfileName:[self.userForProfile objectForKey:kStringrUserDisplayNameKey]];
    [editProfileVC setFillerDescription:topVC.profileDescriptionLabel.text];
    [editProfileVC setFillerUniversityName:topVC.profileUniversityLabel.text];
    
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

- (void)setProfileUniversityName:(NSString *)universityName
{
    self.topProfileVC.profileUniversityLabel.text = universityName;
}



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:newStringVC animated:YES];
    } else if (buttonIndex == 1) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
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
