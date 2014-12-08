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
#import "UIFont+StringrFonts.h"
#import "StringrFollowingTableViewController.h"
#import "ACPButton.h"
#import "StringrConnectionsTableViewController.h"
#import "StringrSegmentedView.h"
#import "StringrFollowingTableViewController.h"
#import "StringrNavigateCommand.h"

static NSString * const StringrProfileStoryboardName = @"StringrProfileStoryboard";

/**
 * Initialize's a user profile as a parallax view controller. The top half is a users information and
 * the bottom is a tableView of their String's. You must provide a user for the profile in order for it to work
 * as well as a profileReturnState. The return state refers to how the profile is being displayed: From the menu,
 * as a modal presentation, or just pushed onto a nav controller. The return state provides information on what return
 * navigation item will be displayed.
 */
@interface StringrProfileViewController () <StringrEditProfileDelegate, UIActionSheetDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *profileViewControllers;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet StringrPathImageView *profileImage;
@property (strong, nonatomic) IBOutlet ACPButton *followButton;
@property (strong, nonatomic) IBOutlet ACPButton *followingButton;
@property (strong, nonatomic) IBOutlet ACPButton *followersButton;

@property (strong, nonatomic) IBOutlet UILabel *followLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;
@property (strong, nonatomic) IBOutlet UILabel *followersLabel;

@property (strong, nonatomic) IBOutlet UILabel *profileDescriptionLabel;

@property (strong, nonatomic) IBOutlet StringrSegmentedView *segmentedControl;

@property (strong, nonatomic) NSTimer *usernameAndDisplayNameAnimationTimer;

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
    
    [self setupAppearance];
    [self loadProfile];
    
    StringrNavigateCommand *command = self.profileViewControllers[0];
    [command execute];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.usernameAndDisplayNameAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setupAnimatedProfileName) userInfo:nil repeats:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.usernameAndDisplayNameAnimationTimer invalidate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"profilePageViewSegue"]) {
        self.pageViewController = segue.destinationViewController;
    }
}


#pragma mark - Accessors

- (NSArray *)profileViewControllers
{
    if (!_profileViewControllers) {
        NSArray *controllerNames = @[@"StringrFollowingTableViewController", @"StringrPopularTableViewController", @"StringrDiscoveryTableViewController", @"StringrFollowingTableViewController"];
        
        NSMutableArray *profileViewControllers = [[NSMutableArray alloc] initWithCapacity:controllerNames.count];
        
        for (NSString *name in controllerNames) {
            StringrNavigateCommand *command = [[StringrNavigateCommand alloc] initWithViewControllerClass:NSClassFromString(name) delegate:self];
            
            command.segmentDisplayBlock = ^(UIViewController *viewController) {
                [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            };
                 
            [profileViewControllers addObject:command];
        }
        
        _profileViewControllers = profileViewControllers;
    }
    
    return _profileViewControllers;
}


#pragma mark - Private

- (void)setupAppearance
{
    [self.profileImage setImage:[UIImage imageNamed:@"stringr_icon_filler"]];
    [self.profileImage setupImageWithDefaultConfiguration];
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    self.usernameLabel.font = [UIFont stringrProfileNameFont];
    self.usernameLabel.textColor = [UIColor darkGrayColor];
    
    self.profileDescriptionLabel.font = [UIFont stringrProfileDescriptionFont];
    self.profileDescriptionLabel.textColor = [UIColor stringrSecondaryLabelColor];
    
    StringrSegment *primarySegment = [StringrSegment new];
    primarySegment.title = @"207";
    primarySegment.imageName = @"liked_strings_icon";

    StringrSegment *segment = [StringrSegment new];
    segment.title = @"149";
    segment.imageName = @"liked_strings_icon";
    
    self.segmentedControl.segments = @[primarySegment, segment, segment, segment];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlIndexDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [self configureFollowingAndFollowersButton];
}


- (void)setupAnimatedProfileName
{
    NSString *nameToDisplay = @"";
    
    // changes the name between user username and displayname
    if ([self.usernameLabel.text isEqualToString:[StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]]]) {
        nameToDisplay = [self.userForProfile objectForKey:kStringrUserDisplayNameKey];
    } else {
        nameToDisplay = [StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]];
    }
    
    [UIView transitionWithView:self.usernameLabel
                      duration:0.5 options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        self.usernameLabel.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [UIView transitionWithView:self.usernameLabel duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            [self.usernameLabel setText:nameToDisplay];
                            self.usernameLabel.alpha = 1.0f;
                        } completion:nil];
                    }];
}


- (void)loadProfile
{
    [self.profileImage setFile:[self.userForProfile objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImage loadInBackgroundWithIndicator];
    
    [self.usernameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]]];
    
    [self.profileDescriptionLabel setText:self.userForProfile[kStringrUserDescriptionKey]];
    
    [self queryAndSetupUserProfileDetails];
}


- (void)queryAndSetupUserProfileDetails
{
    NSDictionary *userAttributes = [[StringrCache sharedCache] attributesForUser:self.userForProfile];
    
    
    // sets the number of following/followers/number of Strings text for the users profile
    // Sets via cache if available and querries if not
//    if (userAttributes) {
//        NSNumber *currentUserFollowingCount = [[StringrCache sharedCache] followingCountForUser:self.userForProfile];
//        [self.followingButton setTitle:[NSString stringWithFormat:@"%d", [currentUserFollowingCount intValue]] forState:UIControlStateNormal];
//        
//        NSNumber *currentUserFollowerCount = [[StringrCache sharedCache] followerCountForUser:self.userForProfile];
//        [self.followersButton setTitle:[NSString stringWithFormat:@"%d", [currentUserFollowerCount intValue]] forState:UIControlStateNormal];
//        
//        NSNumber *numberOfStrings = [[StringrCache sharedCache] stringCountForUser:self.userForProfile];
//        NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", [numberOfStrings intValue]];
//        if ([numberOfStrings intValue] == 1) {
//            numberOfStringsText = [NSString stringWithFormat:@"%d String", [numberOfStrings intValue]];
//        }
////        [self.profileNumberOfStringsLabel setText:numberOfStringsText];
//    }
//    
//    else {
        @synchronized(self) {
            PFQuery *followingUserActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
            [followingUserActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
            [followingUserActivityQuery whereKey:kStringrActivityFromUserKey equalTo:self.userForProfile];
            [followingUserActivityQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error ) {
                if (!error) {
                    [self.followingButton setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
                    [[StringrCache sharedCache] setFollowingCount:@(number) forUser:self.userForProfile];
                }
            }];
            
            PFQuery *followersUserActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
            [followersUserActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
            [followersUserActivityQuery whereKey:kStringrActivityToUserKey equalTo:self.userForProfile];
            [followersUserActivityQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (!error) {
                    [self.followersButton setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
                    [[StringrCache sharedCache] setFollowerCount:@(number) forUser:self.userForProfile];
                }
            }];
            
            PFQuery *numberOfStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
            [numberOfStringsQuery whereKey:kStringrStringUserKey equalTo:self.userForProfile];
            [numberOfStringsQuery countObjectsInBackgroundWithBlock:^(int numberOfStrings, NSError *error) {
                if (!error) {
                    NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", numberOfStrings];
                    if (numberOfStrings == 1) {
                        numberOfStringsText = [NSString stringWithFormat:@"%d String", numberOfStrings];
                    }
                    
//                    [self.profileNumberOfStringsLabel setText:numberOfStringsText];
                    [[StringrCache sharedCache] setStringCount:@(numberOfStrings) forUser:self.userForProfile];
                }
            }];
        }
//    }
    
    // loads follow button and determines the status of the current user following the profile user
//    self.followUserButtonLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    CGFloat buttonHeight = CGRectGetHeight(self.followUserButton.frame);
//    CGFloat buttonWidth = CGRectGetWidth(self.followUserButton.frame);
//    [self.followUserButtonLoadingIndicator setCenter:CGPointMake(buttonWidth / 2, buttonHeight / 2)];
//    [self.followUserButton addSubview:self.followUserButtonLoadingIndicator];
    
    if (![[self.userForProfile objectId] isEqualToString:[[PFUser currentUser] objectId]] ) {
        
//        [self.followUserButtonLoadingIndicator startAnimating];
        
        if (userAttributes) {
            BOOL currentUserIsFollowingProfileUser = [[StringrCache sharedCache] followStatusForUser:self.userForProfile];
            
            if (currentUserIsFollowingProfileUser) {
//                [self configureUnfollowButton];
            } else {
//                [self configureFollowButton];
            }
            
//            [self.followUserButtonLoadingIndicator stopAnimating];
        } else {
            @synchronized(self){
                PFQuery *userIsFollowingUserQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
                [userIsFollowingUserQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
                [userIsFollowingUserQuery whereKey:kStringrActivityToUserKey equalTo:self.userForProfile];
                [userIsFollowingUserQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
                [userIsFollowingUserQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
                [userIsFollowingUserQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if (error && error.code != kPFErrorCacheMiss) {
                        NSLog(@"Couldn't determine follow relationship: %@", error);
                    } else {
//                        [self.followUserButtonLoadingIndicator stopAnimating];
                        if (number == 0) {
//                            [self configureFollowButton];
                            [[StringrCache sharedCache] setFollowStatus:NO forUser:self.userForProfile];
                        } else {
//                            [self configureUnfollowButton];
                            [[StringrCache sharedCache] setFollowStatus:YES forUser:self.userForProfile];
                        }
                    }
                }];
            }
        }
    } else {
        // button setup for when it's the current users profile
//        [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
//        [self.followUserButton setLabelTextColor:[UIColor stringrLightGrayColor] highlightedColor:nil disableColor:nil];
//        [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
//        [self.followUserButton setCornerRadius:15];
//        [self.followUserButton setBorderStyle:[UIColor stringrLightGrayColor] andInnerColor:nil];
//        [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
//        [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
//        [self.followUserButton setEnabled:NO];
    }
}


- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}


- (void)configureFollowingAndFollowersButton
{
    [self.followButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followButton setCornerRadius:CGRectGetWidth(self.followingButton.frame) / 2];
    [self.followButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:16.0f]];
    [self.followButton setTitle:@"0" forState:UIControlStateNormal];
    [self.followButton.titleLabel setTextColor:[UIColor darkGrayColor]];
    
    [self.followingButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followingButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followingButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followingButton setCornerRadius:CGRectGetWidth(self.followingButton.frame) / 2];
    [self.followingButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followingButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:16.0f]];
    [self.followingButton setTitle:@"0" forState:UIControlStateNormal];
    [self.followingButton.titleLabel setTextColor:[UIColor darkGrayColor]];
    
    [self.followersButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followersButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followersButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followersButton setCornerRadius:CGRectGetWidth(self.followersButton.frame) / 2];
    [self.followersButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followersButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:16.0f]];
    [self.followersButton setTitle:@"0" forState:UIControlStateNormal];
    [self.followersButton.titleLabel setTextColor:[UIColor darkGrayColor]];
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
    /*
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEditProfileID];
    StringrProfileTopViewController *topVC = (StringrProfileTopViewController *)self.topViewController;
    
    [editProfileVC setFillerProfileImage:topVC.profileImage];
    [editProfileVC setFillerProfileName:[self.userForProfile objectForKey:kStringrUserDisplayNameKey]];
    [editProfileVC setFillerDescription:topVC.profileDescriptionLabel.text];
    
    [editProfileVC setDelegate:self];
    
    [self.navigationController pushViewController:editProfileVC animated:YES];
     */
}


- (IBAction)accessFollowers:(UIButton *)sender
{
    StringrConnectionsTableViewController *followersVC = [StringrConnectionsTableViewController viewController];
    followersVC.title = @"Followers";
    followersVC.userForConnections = self.userForProfile;
    followersVC.connectionType = UserConnectionFollowersType;
    
    [self.navigationController pushViewController:followersVC animated:YES];
}


- (IBAction)accessFollowing:(UIButton *)sender
{
    StringrConnectionsTableViewController *followingVC = [StringrConnectionsTableViewController viewController];
    followingVC.title = @"Following";
    followingVC.userForConnections = self.userForProfile;
    followingVC.connectionType = UserConnectionFollowingType;
    
    [self.navigationController pushViewController:followingVC animated:YES];
}


- (IBAction)segmentedControlIndexDidChange:(StringrSegmentedView *)segmentedView
{
    NSInteger currentIndex = segmentedView.selectedSegmentIndex;
    
    StringrNavigateCommand *command = self.profileViewControllers[currentIndex];
    [command execute];
}



#pragma mark - StringrEditProfile Delegate

- (void)setProfilePhoto:(UIImage *)profilePhoto
{
//    [self.topProfileVC.profileImage setImage:profilePhoto];
}

- (void)setProfileName:(NSString *)name
{
//    self.topProfileVC.profileNameLabel.text = name;
}

- (void)setProfileDescription:(NSString *)description
{
//    self.topProfileVC.profileDescriptionLabel.text = description;
}


#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if (index == self.profileViewControllers.count - 1) {
        return nil;
    }
    
    StringrNavigateCommand *command = self.profileViewControllers[--index];
    
    return command.viewController;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if (index == 0) {
        return nil;
    }
    
    StringrNavigateCommand *command = self.profileViewControllers[++index];
    
    return command.viewController;
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


@end
