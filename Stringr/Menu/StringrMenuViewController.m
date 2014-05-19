//
//  StringrMenuViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMenuViewController.h"
#import "StringrNavigationController.h"
#import "StringrRootViewController.h"

#import "StringrProfileViewController.h"
#import "StringrMyStringsTableViewController.h"
#import "StringrLikedStringsTableViewController.h"

#import "StringrDiscoveryTabBarViewController.h"
#import "StringrSearchTabBarViewController.h"
#import "StringrSearchTableViewController.h"
#import "StringrUserSearchViewController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrLikedTabBarViewController.h"

#import "StringrStringDetailViewController.h"

#import "StringrSettingsTableViewController.h"
#import "StringrLoginViewController.h"

#import "UIViewController+REFrostedViewController.h"
#import "StringrPathImageView.h"

#import "AppDelegate.h"

#import "StringrLikedPhotosTableViewController.h"


@interface StringrMenuViewController () <UIActionSheetDelegate>

@property (strong,nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UIButton *settingsButton;
@property (strong, nonatomic) UILabel *profileNameLabel;
@property (strong, nonatomic) StringrPathImageView *profileImageView;
@property (strong, nonatomic) NSArray *menuRowTitles;

@end

@implementation StringrMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO; // Allows transparency
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setClearsSelectionOnViewWillAppear:NO];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // I setup the table header view in viewWillAppear to ensure that the correct username and profile image is displayed
    // for the currently logged in user. 
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)
                                                                  image:[UIImage imageNamed:@"stringr_icon_filler"]
                                                              pathColor:[UIColor darkGrayColor]
                                                              pathWidth:1.0];
    
    // loads user profile image in background
    [self.profileImageView setFile:[[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImageView loadInBackgroundWithIndicator];
    
    [self.profileImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    
    self.profileNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.profileNameLabel.adjustsFontSizeToFitWidth = YES;
    self.profileNameLabel.minimumScaleFactor = 0.5f;
    
    // parse user profile name
    self.profileNameLabel.text = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
    
    
    self.profileNameLabel.backgroundColor = [UIColor clearColor];
    self.profileNameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel sizeToFit];
    self.profileNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // Creates the header of the menu that contains profile image and other graphics
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(202, 24, 30, 30)];
    [self.cameraButton setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *settingsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsImage setImage:[UIImage imageNamed:@"settings_button"]];
    
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 26.5, 30, 30)];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings_button"] forState:UIControlStateNormal];
    [self.settingsButton addTarget:self action:@selector(settingsButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.cameraButton];
    [view addSubview:self.settingsButton];
    [view addSubview:self.profileImageView];
    [view addSubview:self.profileNameLabel];
    
    
    self.tableView.tableHeaderView = view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfileImage:) name:kNSNotificationCenterUpdateMenuProfileImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfileName:) name:kNSNotificationCenterUpdateMenuProfileName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterUpdateMenuProfileImage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterUpdateMenuProfileName object:nil];
}
/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)
                                                                  image:[UIImage imageNamed:@"stringr_icon_filler"]
                                                              pathColor:[UIColor darkGrayColor]
                                                              pathWidth:1.0];
    
    // loads user profile image in background
    [self.profileImageView setFile:[[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey]];
    [self.profileImageView loadInBackground];
    
    [self.profileImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    
    self.profileNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.profileNameLabel.adjustsFontSizeToFitWidth = YES;
    self.profileNameLabel.minimumScaleFactor = 0.5f;
    
    // parse user profile name
    self.profileNameLabel.text = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
    
    
    self.profileNameLabel.backgroundColor = [UIColor clearColor];
    self.profileNameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel sizeToFit];
    self.profileNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // Creates the header of the menu that contains profile image and other graphics
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(202, 24, 30, 30)];
    [self.cameraButton setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:self.cameraButton];
    [view addSubview:self.profileImageView];
    [view addSubview:self.profileNameLabel];
    
    
    self.tableView.tableHeaderView = view;
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"dealloc menu");
}



#pragma mark - Custom Accessors

- (NSArray *)menuRowTitles
{
    if (!_menuRowTitles) {
        _menuRowTitles = [[NSArray alloc] initWithObjects:@"Home", @"My Profile", @"My Strings", @"Liked", @"Explore", @"Search", nil];
    }
    
    return _menuRowTitles;
}




#pragma mark - Action Handlers

- (void)cameraButtonTouchHandler:(UIButton *)sender
{
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)settingsButtonTouchHandler:(UIButton *)sender
{
    StringrSettingsTableViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSettingsID];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:settingsVC];
    
    [self.frostedViewController setContentViewController:navVC];
    
    [self.frostedViewController hideMenuViewController];
}

// loaded from editing user profile
- (void)updateUserProfileImage:(NSNotification *)notification
{
    UIImage *newProfileImage = notification.object;
    [self.profileImageView setImage:newProfileImage];
}

// loaded from editing user profile
- (void)updateUserProfileName:(NSNotification *)notification
{
    NSString *newProfileName = notification.object;
    [self.profileNameLabel setText:newProfileName];
}




#pragma mark - Private

- (StringrHomeTabBarViewController *)setupHomeTabBarController
{
    StringrHomeTabBarViewController *homeTabBarVC = [[StringrHomeTabBarViewController alloc] init];
    
    StringrStringTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringTableID];
    [followingVC setTitle:@"Following"];
    
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:1000];
    [followingUsersQuery orderByDescending:@"createdAt"];
    
    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    [followingUsersQuery orderByDescending:@"createdAt"];
    
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByDescending:@"createdAt"];

    [followingVC setQueryForTable:query];
    
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    
    StringrActivityTableViewController *activityVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardActivityTableID];
    [activityVC setTitle:@"Activity"];
    
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activity_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    [homeTabBarVC setViewControllers:@[followingNavVC, activityNavVC]];
    
    return homeTabBarVC;
}

- (StringrLikedTabBarViewController *)setupLikedTabBarController
{
    StringrLikedTabBarViewController *likedTabBarVC = [[StringrLikedTabBarViewController alloc] init];
    
    StringrLikedStringsTableViewController *likedStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardLikedStringsID];
    StringrNavigationController *likedStringsNavVC = [[StringrNavigationController alloc] initWithRootViewController:likedStringsVC];
    
    UITabBarItem *likedStringsTab = [[UITabBarItem alloc] initWithTitle:@"Strings" image:[UIImage imageNamed:@"liked_strings_icon"] tag:0];
    [likedStringsNavVC setTabBarItem:likedStringsTab];
    
    
    StringrLikedPhotosTableViewController *likedPhotosVC = [[StringrLikedPhotosTableViewController alloc] initWithStyle:UITableViewStylePlain];
    StringrNavigationController *likedPhotosNavVC = [[StringrNavigationController alloc] initWithRootViewController:likedPhotosVC];
    
    UITabBarItem *likedPhotosTab = [[UITabBarItem alloc] initWithTitle:@"Liked Photos" image:[UIImage imageNamed:@"photo_icon"] tag:0];
    [likedPhotosNavVC setTabBarItem:likedPhotosTab];
    
    
    [likedTabBarVC setViewControllers:@[likedStringsNavVC, likedPhotosNavVC]];
    
    return likedTabBarVC;
}

- (StringrDiscoveryTabBarViewController *)setupDiscoveryTabBarController
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [[StringrDiscoveryTabBarViewController alloc] init];
    
    StringrStringTableViewController *popularVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringTableID];
    [popularVC setTitle:@"Popular"];
    
    PFQuery *popularQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
    [popularQuery whereKeyExists:kStringrStatisticsStringKey];
    [popularQuery includeKey:kStringrStatisticsStringKey];
    [popularQuery orderByDescending:kStringrStatisticsCommentCountKey];
    [popularQuery addDescendingOrder:kStringrStatisticsLikeCountKey];
    [popularQuery setLimit:100];
    [popularVC setQueryForTable:popularQuery];
    
    StringrNavigationController *popularNavVC = [[StringrNavigationController alloc] initWithRootViewController:popularVC];
    UITabBarItem *popularTab = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"crown_icon"] tag:0];
    [popularNavVC setTabBarItem:popularTab];
    
    
    StringrStringTableViewController *discoverVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringTableID];
    [discoverVC setTitle:@"Discover"];
    
    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [discoverQuery orderByDescending:@"updatedAt"];
    [discoverVC setQueryForTable:discoverQuery];
    
    StringrNavigationController *discoverNavVC = [[StringrNavigationController alloc] initWithRootViewController:discoverVC];
    UITabBarItem *discoverTab = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [discoverNavVC setTabBarItem:discoverTab];
    
    
    StringrStringTableViewController *nearYouVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringTableID];
    [nearYouVC setTitle:@"Near You"];
    
    
    PFQuery *nearYouQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    if ([[PFUser currentUser] objectForKey:kStringrUserLocationKey]) {
        [nearYouQuery whereKey:kStringrStringLocationKey nearGeoPoint:[[PFUser currentUser] objectForKey:kStringrUserLocationKey] withinMiles:100.0];
    } else {
        [nearYouQuery whereKey:kStringrStringTitleKey equalTo:@"!@#%@#$^%^&*"];
    }
    [nearYouQuery orderByDescending:@"createdAt"];
    [nearYouVC setQueryForTable:nearYouQuery];
    
    StringrNavigationController *nearYouNavVC = [[StringrNavigationController alloc] initWithRootViewController:nearYouVC];
    
    UITabBarItem *nearYouTab = [[UITabBarItem alloc] initWithTitle:@"Near You" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
    [nearYouNavVC setTabBarItem:nearYouTab];
    
    [discoveryTabBarVC setViewControllers:@[popularNavVC, discoverNavVC, nearYouNavVC]];
    
    
    return discoveryTabBarVC;
}

- (StringrSearchTabBarViewController *)setupSearchTabBarController
{
    StringrSearchTabBarViewController *searchTabBarVC = [[StringrSearchTabBarViewController alloc] init];
    
    StringrSearchTableViewController *searchStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSearchStringsID];
    
    /*
    PFQuery *searchStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [searchStringsQuery orderByAscending:@"createdAt"];
    [searchStringsVC setQueryForTable:searchStringsQuery];
     */
    
    StringrNavigationController *searchStringsNavVC = [[StringrNavigationController alloc] initWithRootViewController:searchStringsVC];
    UITabBarItem *searchStringsTab = [[UITabBarItem alloc] initWithTitle:@"Search Strings" image:[UIImage imageNamed:@"string_icon"] tag:0];
    [searchStringsNavVC setTabBarItem:searchStringsTab];
    
    
    StringrUserSearchViewController *searchUsersVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSearchUsersID];
    
    /*
    PFQuery *queryForUsers = [PFUser query];
    [queryForUsers orderByAscending:@"displayName"];
    [searchUsersVC setQueryForTable:queryForUsers];
     */
    
    StringrNavigationController *searchUsersNavVC = [[StringrNavigationController alloc] initWithRootViewController:searchUsersVC];
    UITabBarItem *searchUsersTab = [[UITabBarItem alloc] initWithTitle:@"Find People" image:[UIImage imageNamed:@"users_icon"] tag:0];
    [searchUsersNavVC setTabBarItem:searchUsersTab];
    
    [searchTabBarVC setViewControllers:@[searchStringsNavVC, searchUsersNavVC]];
    
    
    return searchTabBarVC;
}




#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuRowTitles.count;
    /*
    if (sectionIndex == 0) {
        return 3;
    } else if (sectionIndex == 1) {
        return 3;
    } else if (sectionIndex == 2) {
        return 2;
    }
    
    return 0;
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = self.menuRowTitles[indexPath.row];

        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    }
    
    return cell;
}




#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    // Instance of our navigation controller, which is the frostedVC
    //UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    // Table section 0 menu items actions
    if (indexPath.row == 0) {
        StringrHomeTabBarViewController *homeTabBarVC = [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupHomeTabBarController];
        
        [self.frostedViewController setContentViewController:homeTabBarVC];
    } else if (indexPath.row == 1) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        
        [profileVC setUserForProfile:[PFUser currentUser]];
        [profileVC setProfileReturnState:ProfileMenuReturnState];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 2) {
        StringrMyStringsTableViewController *myStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardMyStringsID];
        [myStringsVC setTitle:@"My Strings"];

        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:myStringsVC];
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 3) {
        [self.frostedViewController setContentViewController:[self setupLikedTabBarController]];
    } else if (indexPath.row == 4) {
        [self.frostedViewController setContentViewController:[self setupDiscoveryTabBarController]];
        
    } else if (indexPath.row == 5) {
         [self.frostedViewController setContentViewController:[self setupSearchTabBarController]];
    }
    
    // Closes the menu after a user selects an item
    [self.frostedViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.38f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0.0f;
    
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blankFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.0f, 0.0f)];
    return blankFooterView;
}



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    } else if (buttonIndex == 1) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    }
}

@end
