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
#import "StringrNavigateProfileCommand.h"
#import "StringrSettingsTableViewController.h"
#import "StringrNavigationController.h"

#import "StringrStringProfileTableViewController.h"
#import "StringrPhotoCollectionViewController.h"
#import "StringrContainerScrollViewDelegate.h"

static NSString * const StringrProfileStoryboardName = @"StringrProfileStoryboard";

/**
 * Initialize's a user profile as a parallax view controller. The top half is a users information and
 * the bottom is a tableView of their String's. You must provide a user for the profile in order for it to work
 * as well as a profileReturnState. The return state refers to how the profile is being displayed: From the menu,
 * as a modal presentation, or just pushed onto a nav controller. The return state provides information on what return
 * navigation item will be displayed.
 */
@interface StringrProfileViewController () <StringrEditProfileDelegate, UIActionSheetDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, StringrContainerScrollViewDelegate>

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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *profileContainerHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *profileContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileContainerSegmentTopConstraint;

@property (nonatomic) BOOL isScrollingContainerView;
@property (nonatomic) CGFloat currentScrollViewTopInset;

@end

@implementation StringrProfileViewController

#pragma mark - Lifecycle

+ (StringrProfileViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrProfileStoryboardName bundle:nil];
    
    return (StringrProfileViewController *)[storyboard instantiateInitialViewController];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Profile";
    
    // Guarantee's that if the passed in user is the current user we provide the ability to edit that profile
    if (self.isDashboardProfile) {
        self.navigationItem.title = @"My Profile";
        
        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings_button"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToEditProfile)];
        
        UIBarButtonItem *editStringsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liked_strings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(adjustScrollView)];
        
        self.navigationItem.rightBarButtonItems = @[settingsButton, editStringsButton];
    }
    
    // Sets the 'return' button based off of what state the profile is in. Modal, Menu, or Back.
    if (self.profileReturnState == ProfileModalReturnState) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeProfileVC)];
    } else if (self.profileReturnState == ProfileMenuReturnState) {
        
    }
    
    [self setupAppearance];
    [self loadProfile];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTopProfileView:)];
//    [self.profileContainerView addGestureRecognizer:panGesture];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.usernameAndDisplayNameAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(setupAnimatedProfileName) userInfo:nil repeats:YES];
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


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.isScrollingContainerView) return;
    
    self.currentScrollViewTopInset = self.profileContainerView.frame.size.height;
    
    StringrNavigateProfileCommand *command = self.profileViewControllers[0];
    [command execute];
}


#pragma mark - Accessors

- (NSArray *)profileViewControllers
{
    // Lazily instantiate the array of container view controllers.
    // Each one object creates a command, which then lazily instantiates the vc itself
    if (!_profileViewControllers) {
        NSArray *controllerCommandTypes = @[@(ProfileCommandUserStrings), @(ProfileCommandLikedStrings), @(ProfileCommandLikedPhotos), @(ProfileCommandPublicPhotos)];
        
        NSMutableArray *profileViewControllers = [[NSMutableArray alloc] initWithCapacity:controllerCommandTypes.count];
        
        for (NSNumber *commandNumber in controllerCommandTypes) {
            ProfileCommandType commandType = [commandNumber intValue];
            
            StringrNavigateProfileCommand *command = [StringrNavigateProfileCommand new];
            command.commandType = commandType;
            command.delegate = self;
            command.user = self.userForProfile;
            
            command.segmentDisplayBlock = ^(UIViewController <StringrContainerScrollViewDelegate>*viewController) {
                [viewController adjustScrollViewTopInset:self.currentScrollViewTopInset];
                
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
    self.profileDescriptionLabel.textColor = [UIColor stringrPrimaryLabelColor];
    
    StringrSegment *primarySegment = [StringrSegment new];
    primarySegment.title = @"207";
    primarySegment.imageName = @"StringIcon";

    StringrSegment *segment = [StringrSegment new];
    segment.title = @"149";
    segment.imageName = @"StringIcon";
    
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
            
//            PFQuery *numberOfStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
//            [numberOfStringsQuery whereKey:kStringrStringUserKey equalTo:self.userForProfile];
//            [numberOfStringsQuery countObjectsInBackgroundWithBlock:^(int numberOfStrings, NSError *error) {
//                if (!error) {
//                    NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", numberOfStrings];
//                    if (numberOfStrings == 1) {
//                        numberOfStringsText = [NSString stringWithFormat:@"%d String", numberOfStrings];
//                    }
//                    
////                    [self.profileNumberOfStringsLabel setText:numberOfStringsText];
//                    [[StringrCache sharedCache] setStringCount:@(numberOfStrings) forUser:self.userForProfile];
//                }
//            }];
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
                [self configureUnfollowButton];
            } else {
                [self configureFollowButton];
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
                            [self configureFollowButton];
//                            [[StringrCache sharedCache] setFollowStatus:NO forUser:self.userForProfile];
                        } else {
                            [self configureUnfollowButton];
//                            [[StringrCache sharedCache] setFollowStatus:YES forUser:self.userForProfile];
                        }
                    }
                }];
            }
        }
    } else {
        // button setup for when it's the current users profile
        [self.followButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
        [self.followButton setLabelTextColor:[UIColor stringrLightGrayColor] highlightedColor:nil disableColor:nil];
        [self.followButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
        [self.followButton setCornerRadius:15];
        [self.followButton setBorderStyle:[UIColor stringrLightGrayColor] andInnerColor:nil];
        self.followButton.tintColor = [UIColor lightGrayColor];
        [self.followButton setEnabled:NO];
        
        self.followLabel.textColor = [UIColor lightGrayColor];
    }
}


- (void)configureFollowButton
{
    [self.followButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followButton setCornerRadius:CGRectGetWidth(self.followingButton.frame) / 2];
    [self.followButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followButton setImage:[UIImage imageNamed:@"StringrDefaultCheckmark"] forState:UIControlStateNormal];
    self.followButton.tintColor = [UIColor lightGrayColor];
    
    self.followLabel.textColor = [UIColor darkGrayColor];
    self.followLabel.text = @"Follow";
}


- (void)configureUnfollowButton
{
    [self.followButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followButton setCornerRadius:CGRectGetWidth(self.followingButton.frame) / 2];
    [self.followButton setBorderStyle:[UIColor stringrLikedGreenColor] andInnerColor:nil];
    [self.followButton setImage:[UIImage imageNamed:@"StringrDefaultCheckmark"] forState:UIControlStateNormal];
    self.followButton.tintColor = [UIColor stringrLikedGreenColor];
    
    self.followLabel.textColor = [UIColor stringrLikedGreenColor];
    self.followLabel.text = @"Unfollow";
}


- (void)configureFollowingAndFollowersButton
{
    [self configureFollowButton];
    
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
    StringrSettingsTableViewController *settingsVC = [StringrSettingsTableViewController viewController];
    
    [self.navigationController pushViewController:settingsVC animated:YES];
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
    
    StringrNavigateProfileCommand *command = self.profileViewControllers[currentIndex];
    [command execute];
    
    if (currentIndex != 0) {
        // hide edit strings tab bar button
    }
}


- (void)panTopProfileView:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    
    UIScrollView *scrollView = [self currentProfileScrollView];
    
    self.isScrollingContainerView = YES;
    
    UIEdgeInsets currentScrollViewInset = scrollView.contentInset;
    CGPoint currentScrollViewOffset = scrollView.contentOffset;
    
    // Since we have an inset the initial scrollViewOffset y value is a positive value that is decreasing
    // because the content is not at the frame's 0,0 position.
    NSInteger dy = (NSInteger)(currentScrollViewInset.top + translation.y);
    
    if (dy < 0 && currentScrollViewInset.top > 0) {
        UIEdgeInsets newInsets = currentScrollViewInset;
        newInsets.top = MAX(currentScrollViewInset.top + dy, 0.);
        scrollView.contentInset = newInsets;
        
        
        self.profileContainerSegmentTopConstraint.constant = -(self.profileContainerView.frame.size.height - newInsets.top);
    }
    else if (dy > 0 && currentScrollViewInset.top < self.profileContainerView.frame.size.height) {
        UIEdgeInsets newInsets = currentScrollViewInset;
        newInsets.top = MIN(currentScrollViewInset.top + dy, self.profileContainerView.frame.size.height);
        scrollView.contentInset = newInsets;
        
        self.profileContainerSegmentTopConstraint.constant = -(self.profileContainerView.frame.size.height - newInsets.top);
    }
    
    self.currentScrollViewTopInset = scrollView.contentInset.top;
}


- (UIScrollView *)currentProfileScrollView
{
    StringrNavigateProfileCommand *command = self.profileViewControllers[self.segmentedControl.selectedSegmentIndex];
    
    UIViewController <StringrContainerScrollViewDelegate>*viewController = command.viewController;
    
    return viewController.containerScrollView;
}

#pragma mark - Stringr Container ScrollView Delegate

- (void)containerViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrollingContainerView = YES;
    
    UIEdgeInsets currentScrollViewInset = scrollView.contentInset;
    CGPoint currentScrollViewOffset = scrollView.contentOffset;
    
    // Since we have an inset the initial scrollViewOffset y value is a positive value that is decreasing
    // because the content is not at the frame's 0,0 position.
    NSInteger dy = -(NSInteger)(currentScrollViewInset.top + currentScrollViewOffset.y);
    
    if (dy < 0 && currentScrollViewInset.top > 0) {
        UIEdgeInsets newInsets = currentScrollViewInset;
        newInsets.top = MAX(currentScrollViewInset.top + dy, 0.);
        scrollView.contentInset = newInsets;
        
        
        self.profileContainerSegmentTopConstraint.constant = -(self.profileContainerView.frame.size.height - newInsets.top);
    }
    else if (dy > 0 && currentScrollViewInset.top < self.profileContainerView.frame.size.height) {
        UIEdgeInsets newInsets = currentScrollViewInset;
        newInsets.top = MIN(currentScrollViewInset.top + dy, self.profileContainerView.frame.size.height);
        scrollView.contentInset = newInsets;
        
        self.profileContainerSegmentTopConstraint.constant = -(self.profileContainerView.frame.size.height - newInsets.top);
    }
    
    self.currentScrollViewTopInset = scrollView.contentInset.top;
}


- (void)containerViewDidScrollDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrollingContainerView = NO;
}


- (void)containerViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isScrollingContainerView = NO;
}


- (BOOL)containerViewShouldScrollToTop:(UIScrollView *)scrollView
{
    UIEdgeInsets newInsets = scrollView.contentInset;
    newInsets.top = self.profileContainerView.frame.size.height;
    scrollView.contentInset = newInsets;

    return YES;
}


- (void)adjustScrollView
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        StringrNavigateProfileCommand *command = self.profileViewControllers[self.segmentedControl.selectedSegmentIndex];
        
        self.profileContainerSegmentTopConstraint.constant = -self.profileContainerView.frame.size.height;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.33 animations:^{
            [command.viewController adjustScrollViewTopInset:0.0f];
            [self.view layoutIfNeeded];
        }];
    }
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
    
    StringrNavigateProfileCommand *command = self.profileViewControllers[--index];
    
    return command.viewController;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if (index == 0) {
        return nil;
    }
    
    StringrNavigateProfileCommand *command = self.profileViewControllers[++index];
    
    return command.viewController;
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        
        [self.navigationController pushViewController:newStringVC animated:YES];
    } else if (buttonIndex == 1) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
}


@end
