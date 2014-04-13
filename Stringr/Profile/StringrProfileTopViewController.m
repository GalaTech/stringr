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


@interface StringrProfileTopViewController ()

@property (weak, nonatomic) IBOutlet ACPButton *followUserButton;
@property (strong, nonatomic) UIActivityIndicatorView *followUserButtonLoadingIndicator;

@property (strong, nonatomic) NSTimer *usernameAndDisplayNameAnimationTimer;

@end

@implementation StringrProfileTopViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    self.view = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileNameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[self.userForProfile objectForKey:kStringrUserUsernameCaseSensitive]]];
    
    [self.profileDescriptionLabel setText:[self.userForProfile objectForKey:kStringrUserDescriptionKey]];
    
    int numberOfStrings = [[self.userForProfile objectForKey:kStringrUserNumberOfStringsKey] intValue];
    
    NSString *numberOfStringsText = [NSString stringWithFormat:@"%d Strings", numberOfStrings];
    if (numberOfStrings == 1) {
        numberOfStringsText = [NSString stringWithFormat:@"%d String", numberOfStrings];
    }
    
    [self.profileNumberOfStringsLabel setText:numberOfStringsText];
    
    
    // Sets the circle image path properties
    
    [self.profileImage setImage:[UIImage imageNamed:@"stringr_icon_filler"]];
    [self.profileImage setFile:[self.userForProfile objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImage loadInBackground];
    
    [self.profileImage setImageToCirclePath];
    [self.profileImage setPathWidth:1.0];
    [self.profileImage setPathColor:[UIColor darkGrayColor]];
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    /*
    PFFile *userProfileImageFile = [self.userForProfile objectForKey:kStringrUserProfilePictureKey];
    [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            [self.profileImage setImage:profileImage];
        }
    }];
     */

    
    // Sets the title of the button to follow or unfollow depending upon what the users
    // relationship is with the current profile.
    // TODO: Set this via StringrCache
    /*
    if (!self.isFollowingUser) {
        [self configureFollowButton];
    } else {
        [self configureUnfollowButton];
    }
     */
    
    
    // loads follow button and determines the status of the current user following the profile user
    self.followUserButtonLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat buttonHeight = CGRectGetHeight(self.followUserButton.frame);
    CGFloat buttonWidth = CGRectGetWidth(self.followUserButton.frame);
    [self.followUserButtonLoadingIndicator setCenter:CGPointMake(buttonWidth / 2, buttonHeight / 2)];
    [self.followUserButton addSubview:self.followUserButtonLoadingIndicator];
    
    if (![[self.userForProfile objectId] isEqualToString:[[PFUser currentUser] objectId]] ) {
    
        [self.followUserButtonLoadingIndicator startAnimating];
        
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
                } else {
                    [self configureUnfollowButton];
                }
            }
        }];
    } else {
        // button setup for when it's the current users profile
        [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[UIColor whiteColor]];
        [self.followUserButton setLabelTextColor:[StringrConstants kStringTableViewBackgroundColor] highlightedColor:nil disableColor:nil];
        [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
        [self.followUserButton setCornerRadius:15];
        [self.followUserButton setBorderStyle:[StringrConstants kStringTableViewBackgroundColor] andInnerColor:nil];
        [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.followUserButton setEnabled:NO];
    }
    
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

- (void)configureFollowButton
{
    [self.followUserButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.followUserButton addTarget:self action:@selector(followButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    // Adds custom design to follow user button
    [self.followUserButton setStyle:[UIColor whiteColor] andBottomColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    [self.followUserButton setTitle:@"Follow" forState:UIControlStateNormal];
}

- (void)configureUnfollowButton
{
    [self.followUserButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.followUserButton addTarget:self action:@selector(unfollowButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    [self.followUserButton setStyle:[StringrConstants kStringTableViewBackgroundColor] andBottomColor:[UIColor whiteColor]];
    [self.followUserButton setLabelTextColor:[UIColor darkGrayColor] highlightedColor:[UIColor darkTextColor] disableColor:nil];
    [self.followUserButton setLabelTextShadow:CGSizeMake(0, 0) normalColor:nil highlightedColor:nil disableColor:nil];
    [self.followUserButton setCornerRadius:15];
    [self.followUserButton setBorderStyle:[UIColor lightGrayColor] andInnerColor:nil];
    [self.followUserButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    [self.followUserButton setTitle:@"Unfollow" forState:UIControlStateNormal];
}




#pragma mark - Action Handler


- (void)followButtonTouchHandler
{
    [self.followUserButtonLoadingIndicator startAnimating];
    [self configureUnfollowButton];
    
    [StringrUtility followUserEventually:self.userForProfile block:^(BOOL succeeded, NSError *error) {
        [self.followUserButtonLoadingIndicator stopAnimating];
        if (error) {
            [self configureFollowButton];
        }
    }];
}

- (void)unfollowButtonTouchHandler
{
    [self configureFollowButton];
    
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
    StringrUserTableViewController *followersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersVC"];
    
    /*
    PFQuery *followersProfileUserQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followersProfileUserQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followersProfileUserQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    */
    
    PFQuery *followersQuery = [PFUser query];
    [followersQuery orderByAscending:@"displayName"];
    [followersQuery whereKey:kStringrUserDisplayNameKey notEqualTo:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
    [followersVC setQueryForTable:followersQuery];
    
    [followersVC setTitle:@"Followers"];
    
    
    [self.navigationController pushViewController:followersVC animated:YES];
}


- (IBAction)accessFollowing:(UIButton *)sender
{
    StringrUserTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingVC"];
    
    /*
    PFQuery *followingProfileUserQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingProfileUserQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingProfileUserQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingProfileUserQuery setLimit:1000];
    
    PFQuery *usersFromFollowingProfileUsersQuery = [PFUser query];
    */
    
    
    PFQuery *allUserObjects = [PFUser query];
    [allUserObjects findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
        
    }];


    
    PFQuery *followingQuery = [PFUser query];
    [followingQuery orderByAscending:@"displayName"];
    [followingQuery whereKey:kStringrUserDisplayNameKey notEqualTo:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
    [followingVC setQueryForTable:followingQuery];
    
    [followingVC setTitle:@"Following"];
    
    
    [self.navigationController pushViewController:followingVC animated:YES];
}




 

@end
