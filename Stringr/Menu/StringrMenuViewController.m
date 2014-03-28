//
//  StringrMenuViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMenuViewController.h"
#import "StringrNavigationController.h"

#import "StringrProfileViewController.h"
#import "StringrMyStringsTableViewController.h"
#import "StringrLikedStringsTableViewController.h"

#import "StringrDiscoveryTabBarViewController.h"
#import "StringrMySchoolTabBarViewController.h"
#import "StringrSearchTabBarViewController.h"
#import "StringrSearchTableViewController.h"
#import "StringrUserSearchViewController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"

#import "StringrStringDetailViewController.h"

#import "StringrSettingsViewController.h"
#import "StringrLoginViewController.h"

#import "UIViewController+REFrostedViewController.h"
#import "StringrPathImageView.h"

#import "AppDelegate.h"


@interface StringrMenuViewController () <UIActionSheetDelegate>

@property (strong,nonatomic) UIButton *cameraButton;
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
    
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfileImage:) name:kNSNotificationCenterUpdateMenuProfileImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfileName:) name:kNSNotificationCenterUpdateMenuProfileName object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)
                                                                  image:[UIImage imageNamed:@"Stringr Image"]
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
    self.profileNameLabel.text = [[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey];
    
    
    self.profileNameLabel.backgroundColor = [UIColor clearColor];
    self.profileNameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel sizeToFit];
    self.profileNameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // Creates the header of the menu that contains profile image and other graphics
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(202, 24, 30, 30)];
    [self.cameraButton setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:self.cameraButton];
    [view addSubview:self.profileImageView];
    [view addSubview:self.profileNameLabel];
    
    
    self.tableView.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Custom Accessor's

- (NSArray *)menuRowTitles
{
    if (!_menuRowTitles) {
        _menuRowTitles = [[NSArray alloc] initWithObjects:@"Home", @"My Profile", @"My Strings", @"Liked", @"Discover", @"Search", @"Settings", @"Logout", nil];
    }
    
    return _menuRowTitles;
}




#pragma mark - Action Handlers

- (void)cameraButtonPushed:(UIButton *)sender
{
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)updateUserProfileImage:(NSNotification *)notification
{
    UIImage *newProfileImage = notification.object;
    [self.profileImageView setImage:newProfileImage];
    
    /*
    PFFile *userProfileImageFile = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey];
    [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            [self.profileImageView setImage:profileImage];
        }
    }];
     */
}

- (void)updateUserProfileName:(NSNotification *)notification
{
    NSString *newProfileName = notification.object;
    [self.profileNameLabel setText:newProfileName];
    
    //[self.profileNameLabel setText:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
}




#pragma mark - Private


- (StringrHomeTabBarViewController *)setupHomeTabBarController
{
    StringrHomeTabBarViewController *homeTabBarVC = [[StringrHomeTabBarViewController alloc] init];
    
    StringrStringTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [followingVC setTitle:@"Following"];
    
    PFQuery *followingUsersQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUsersQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUsersQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [followingUsersQuery setLimit:1000];
    
    PFQuery *stringsFromFollowedUsersQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [stringsFromFollowedUsersQuery whereKey:kStringrStringUserKey matchesKey:kStringrActivityToUserKey inQuery:followingUsersQuery];
    
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[stringsFromFollowedUsersQuery]];
    [query orderByAscending:@"createdAt"];

    [followingVC setQueryForTable:query];
    
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    
    StringrActivityTableViewController *activityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"activityVC"];
    [activityVC setTitle:@"Activity"];
    
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    
    [homeTabBarVC setViewControllers:@[followingNavVC, activityNavVC]];
    
    return homeTabBarVC;
}

- (StringrDiscoveryTabBarViewController *)setupDiscoveryTabBarController
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [[StringrDiscoveryTabBarViewController alloc] init];
    
    /*
    StringrStringTableViewController *followingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [followingVC setTitle:@"Following"];
    
    PFQuery *followingQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [followingQuery orderByAscending:@"createdAt"];
    [followingVC setQueryForTable:followingQuery];
    
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    */
    
    StringrStringTableViewController *popularVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [popularVC setTitle:@"Popular"];
    
    PFQuery *popularQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [popularQuery orderByDescending:@"createdAt"];
    [popularVC setQueryForTable:popularQuery];
    
    StringrNavigationController *popularNavVC = [[StringrNavigationController alloc] initWithRootViewController:popularVC];
    UITabBarItem *popularTab = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"crown_icon"] tag:0];
    [popularNavVC setTabBarItem:popularTab];
    
    
    StringrStringTableViewController *discoverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [discoverVC setTitle:@"Discover"];
    
    PFQuery *discoverQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [discoverQuery orderByAscending:@"createdAt"];
    [discoverVC setQueryForTable:discoverQuery];
    
    StringrNavigationController *discoverNavVC = [[StringrNavigationController alloc] initWithRootViewController:discoverVC];
    UITabBarItem *discoverTab = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [discoverNavVC setTabBarItem:discoverTab];
    
    
    StringrStringTableViewController *nearYouVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
    [nearYouVC setTitle:@"Near You"];
    
    PFQuery *nearYouQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
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
    
    StringrSearchTableViewController *searchStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchStringsVC"];
    
    PFQuery *searchStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [searchStringsQuery orderByAscending:@"createdAt"];
    [searchStringsVC setQueryForTable:searchStringsQuery];
    
    StringrNavigationController *searchStringsNavVC = [[StringrNavigationController alloc] initWithRootViewController:searchStringsVC];
    UITabBarItem *searchStringsTab = [[UITabBarItem alloc] initWithTitle:@"Search Strings" image:nil tag:0];
    [searchStringsNavVC setTabBarItem:searchStringsTab];
    
    
    StringrUserSearchViewController *searchUsersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchFindPeopleVC"];
    
    PFQuery *queryForUsers = [PFUser query];
    [queryForUsers orderByAscending:@"displayName"];
    [searchUsersVC setQueryForTable:queryForUsers];
    
    StringrNavigationController *searchUsersNavVC = [[StringrNavigationController alloc] initWithRootViewController:searchUsersVC];
    UITabBarItem *searchUsersTab = [[UITabBarItem alloc] initWithTitle:@"Find People" image:nil tag:0];
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
    
    /*
     if (indexPath.section == 0) {
     NSArray *titles = @[@"My Profile", @"My Strings", @"My School", @"Liked Strings"];
     cell.textLabel.text = titles[indexPath.row];
     } else {
     NSArray *titles = @[@"Stringr Discovery", @"Search", @"Settings", @"Logout"];
     cell.textLabel.text = titles[indexPath.row];
     }
    
    NSArray *titles;
    
    switch (indexPath.section) {
        case 0:
            titles = @[@"My Profile", @"My Strings", @"Liked Strings"];
            break;
        case 1:
            titles = @[@"Discover", @"My School", @"Search"];
            break;
        case 2:
            titles = @[@"Settings", @"Logout"];
            break;
    }
     */
    
    
    return cell;
}




#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Instance of our navigation controller, which is the frostedVC
    //UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    // Table section 0 menu items actions
    if (indexPath.row == 0) {
        [self.frostedViewController setContentViewController:[self setupHomeTabBarController]];
        
    } else if (indexPath.row == 1) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        
        [profileVC setUserForProfile:[PFUser currentUser]];
        [profileVC setProfileReturnState:ProfileMenuReturnState];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 2) {
        StringrMyStringsTableViewController *myStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyStringsVC"];
        [myStringsVC setTitle:@"My Strings"];
        
        /*
        PFQuery *myStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [myStringsQuery whereKey:kStringrStringUserKey equalTo:[PFUser currentUser]];
        [myStringsQuery orderByDescending:@"createdAt"];
        [myStringsVC setQueryForTable:myStringsQuery];
        */
         
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:myStringsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 3) {
        StringrLikedStringsTableViewController *likedStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringTableVC"];
        [likedStringsVC setTitle:@"Liked Strings"];
        
        PFQuery *likedStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [likedStringsQuery orderByDescending:@"createdAt"];
        [likedStringsVC setQueryForTable:likedStringsQuery];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:likedStringsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 4) {
        [self.frostedViewController setContentViewController:[self setupDiscoveryTabBarController]];
        
    } else if (indexPath.row == 5) {
         [self.frostedViewController setContentViewController:[self setupSearchTabBarController]];
    } else if (indexPath.row == 6) {
        
        StringrSettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:settingsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.row == 7) {
        [PFQuery clearAllCachedResults];
        [PFUser logOut];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        UIViewController *blankVC = [[UIViewController alloc] init];
        [self.frostedViewController setContentViewController:blankVC];
        
        StringrLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        StringrNavigationController *loginNavVC = [[StringrNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:loginNavVC animated:YES completion:nil];
    }
    
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.38f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    // Creates a custom menu section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    
    // Set the section header text based off of what section it is
    switch (sectionIndex) {
        case 1:
            label.text = @"Discover";
            break;
        case 2:
            label.text = @"Settings";
            break;
        default:
            label.text = @"";
    }
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0.0f;
    
    return 34.0f;
}




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    } else if (buttonIndex == 1) {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
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
