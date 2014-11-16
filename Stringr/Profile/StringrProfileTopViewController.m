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
#import "StringrUserTableViewController.h"
#import "StringrConnectionsTableViewController.h"
#import "StringrPathImageView.h"
#import "ACPButton.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"


@interface StringrProfileTopViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileTopContainerView;

@property (weak, nonatomic) IBOutlet ACPButton *followingButton;
@property (weak, nonatomic) IBOutlet ACPButton *followersButton;
@property (weak, nonatomic) IBOutlet ACPButton *followUserButton;

@property (strong, nonatomic) UIActivityIndicatorView *followUserButtonLoadingIndicator;
@property (strong, nonatomic) NSTimer *usernameAndDisplayNameAnimationTimer;

@end

@implementation StringrProfileTopViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileNameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]]];
    
    NSString *test = [self.userForProfile objectForKey:kStringrUserDescriptionKey];
    
    if (![test isEqualToString:@"Edit your profile to set the description."]) {
        [self.profileDescriptionLabel setText:[self.userForProfile objectForKey:kStringrUserDescriptionKey]];
    }

    // Sets the circle image path properties
    [self.profileImage setImage:[UIImage imageNamed:@"stringr_icon_filler"]];
    [self.profileImage setFile:[self.userForProfile objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImage loadInBackgroundWithIndicator];
    
    [self.profileImage setupImageWithDefaultConfiguration];
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    [self configureFollowingAndFollowersButton];
    
    // sets up the number of followers, following, and strings a user has.
    // It will query for those number the first time, but will then retrieve them
    // from cache in future requests
    [self queryAndSetupUserProfileDetails];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


#pragma mark - Private

- (void)setupAnimatedProfileName
{
    NSString *nameToDisplay = @"";
    
    // changes the name between user username and displayname
    if ([self.profileNameLabel.text isEqualToString:[StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]]]) {
        nameToDisplay = [self.userForProfile objectForKey:kStringrUserDisplayNameKey];
    } else {
        nameToDisplay = [StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]];
    }
    
    [UIView transitionWithView:self.profileNameLabel
                      duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        [self.profileNameLabel setText:nameToDisplay];
                    } completion:nil];
}


- (void)queryAndSetupUserProfileDetails
{
    NSDictionary *userAttributes = [[StringrCache sharedCache] attributesForUser:self.userForProfile];
    
    
    // sets the number of following/followers/number of Strings text for the users profile
    // Sets via cache if available and querries if not
    if (userAttributes) {
        NSNumber *currentUserFollowingCount = [[StringrCache sharedCache] followingCountForUser:self.userForProfile];
        [self.followingButton setTitle:[NSString stringWithFormat:@"%d", [currentUserFollowingCount intValue]] forState:UIControlStateNormal];
        
        NSNumber *currentUserFollowerCount = [[StringrCache sharedCache] followerCountForUser:self.userForProfile];
        [self.followersButton setTitle:[NSString stringWithFormat:@"%d", [currentUserFollowerCount intValue]] forState:UIControlStateNormal];
        
        NSNumber *numberOfStrings = [[StringrCache sharedCache] stringCountForUser:self.userForProfile];
        NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", [numberOfStrings intValue]];
        if ([numberOfStrings intValue] == 1) {
            numberOfStringsText = [NSString stringWithFormat:@"%d String", [numberOfStrings intValue]];
        }
        [self.profileNumberOfStringsLabel setText:numberOfStringsText];
    } else {
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
                    
                    [self.profileNumberOfStringsLabel setText:numberOfStringsText];
                    [[StringrCache sharedCache] setStringCount:@(numberOfStrings) forUser:self.userForProfile];
                }
            }];
        }
    }
    
    // loads follow button and determines the status of the current user following the profile user
    self.followUserButtonLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat buttonHeight = CGRectGetHeight(self.followUserButton.frame);
    CGFloat buttonWidth = CGRectGetWidth(self.followUserButton.frame);
    [self.followUserButtonLoadingIndicator setCenter:CGPointMake(buttonWidth / 2, buttonHeight / 2)];
    [self.followUserButton addSubview:self.followUserButtonLoadingIndicator];
    
    if (![[self.userForProfile objectId] isEqualToString:[[PFUser currentUser] objectId]] ) {
        
        [self.followUserButtonLoadingIndicator startAnimating];
        
        if (userAttributes) {
            BOOL currentUserIsFollowingProfileUser = [[StringrCache sharedCache] followStatusForUser:self.userForProfile];
            
            if (currentUserIsFollowingProfileUser) {
                [self configureUnfollowButton];
            } else {
                [self configureFollowButton];
            }
            
            [self.followUserButtonLoadingIndicator stopAnimating];
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
                        [self.followUserButtonLoadingIndicator stopAnimating];
                        if (number == 0) {
                            [self configureFollowButton];
                            [[StringrCache sharedCache] setFollowStatus:NO forUser:self.userForProfile];
                        } else {
                            [self configureUnfollowButton];
                            [[StringrCache sharedCache] setFollowStatus:YES forUser:self.userForProfile];
                        }
                    }
                }];
            }
        }
    } else {
        // button setup for when it's the current users profile
        [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
        [self.followUserButton setLabelTextColor:[UIColor stringrLightGrayColor] highlightedColor:nil disableColor:nil];
        [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
        [self.followUserButton setCornerRadius:15];
        [self.followUserButton setBorderStyle:[UIColor stringrLightGrayColor] andInnerColor:nil];
        [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.followUserButton setEnabled:NO];
    }
}


- (void)configureFollowButton
{
    [self.followUserButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.followUserButton addTarget:self action:@selector(followButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    // Adds custom design to follow user button
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor darkGrayColor] andInnerColor:nil];
    [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    [self.followUserButton setTitle:@"Follow" forState:UIControlStateNormal];
}


- (void)configureUnfollowButton
{
    [self.followUserButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.followUserButton addTarget:self action:@selector(unfollowButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor darkGrayColor] andInnerColor:nil];
    [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
}


- (void)configureFollowingAndFollowersButton
{
    [self.followingButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followingButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followingButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followingButton setCornerRadius:CGRectGetWidth(self.followingButton.frame) / 2];
    [self.followingButton setBorderStyle:[UIColor darkGrayColor] andInnerColor:nil];
    [self.followingButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [self.followingButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.followersButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
    [self.followersButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followersButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followersButton setCornerRadius:CGRectGetWidth(self.followersButton.frame) / 2];
    [self.followersButton setBorderStyle:[UIColor darkGrayColor] andInnerColor:nil];
    [self.followersButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [self.followersButton setTitle:@"0" forState:UIControlStateNormal];
}



#pragma mark - Action Handler

- (void)followButtonTouchHandler
{
    [self.followUserButtonLoadingIndicator startAnimating];
    [self configureUnfollowButton];
    [[StringrCache sharedCache] setFollowStatus:YES forUser:self.userForProfile];
    
    [StringrUtility followUserEventually:self.userForProfile block:^(BOOL succeeded, NSError *error) {
        [self.followUserButtonLoadingIndicator stopAnimating];
        [StringrUtility sendFollowingPushNotification:self.userForProfile];
        if (error) {
            [self configureFollowButton];
        }
    }];
}

- (void)unfollowButtonTouchHandler
{
    [self configureFollowButton];
    
    [[StringrCache sharedCache] setFollowStatus:NO forUser:self.userForProfile];
    [StringrUtility unfollowUserEventually:self.userForProfile];
}



#pragma mark - IBActions

- (IBAction)followUserButton:(UIButton *)sender
{
    if (!self.isFollowingUser) {
        [self configureUnfollowButton];
    } else {
        [self configureFollowButton];
    }
    
    self.isFollowingUser = !self.isFollowingUser;
     
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


@end
