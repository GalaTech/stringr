//
//  StringrUserTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewController.h"
#import "StringrProfileViewController.h"
#import "StringrPathImageView.h"
#import "StringrUserTableViewCell.h"
#import "StringrStringDetailViewController.h"

@interface StringrUserTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation StringrUserTableViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrUserClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 1;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"dealloc user table");
}



#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // test number. This will eventually be pulled via the number of object's returned from parse
    return self.objects.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UserProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrUserTableViewCell class]]) {
        
        StringrUserTableViewCell * userProfileCell = (StringrUserTableViewCell *)cell;
    
        // Creates the path and image for a profile thumbnail
        StringrPathImageView *cellProfileImage = (StringrPathImageView *)[self.view viewWithTag:1];
        [cellProfileImage setImageToCirclePath];
        [cellProfileImage setPathColor:[UIColor darkGrayColor]];
        [cellProfileImage setPathWidth:1.0];
        
 
        PFImageView *profileImageView = [[PFImageView alloc] init];
        profileImageView.image = [UIImage imageNamed:@"Stringr Image"];
        profileImageView.file = (PFFile *)[[PFUser currentUser] objectForKey:kStringrUserProfilePictureThumbnailKey];
        cellProfileImage.image = profileImageView.image;
        [profileImageView loadInBackground];
 
         
        // Sets the profile image on the current cell
        // TODO: This will eventually be the profile image pulled from parse
        userProfileCell.ProfileThumbnailImageView = cellProfileImage;
        
        
        [userProfileCell.profileDisplayNameLabel setText:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
        [userProfileCell.profileUniversityNameLabel setText:[[PFUser currentUser] objectForKey:kStringrUserSelectedUniversityKey]];

        PFQuery *numberOfStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [numberOfStringsQuery whereKey:kStringrStringUserKey equalTo:[PFUser currentUser]];
        
        [numberOfStringsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                userProfileCell.profileNumberOfStringsLabel.text = [NSString stringWithFormat:@"%d", number];
            }
        }];
        
        
    }

    return cell;
}
*/



#pragma mark - Table View Delegate

// Takes the user to the profile of the selected user cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Creates a new instance of a user profile
    StringrProfileViewController *profileVC = [StringrProfileViewController viewController];

    // Gets the cell that the user tapped on
    StringrUserTableViewCell *currentCell = (StringrUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (currentCell) {
        // Sets the title of the profile vc being pushed to that of the username on the cell being tapped
        //profileVC.title = @"Profile";
        
        //[profileVC setUserForProfile:[PFUser currentUser]];
        [profileVC setUserForProfile:[self.objects objectAtIndex:indexPath.row]];
        [profileVC setProfileReturnState:ProfileBackReturnState];
        
        //profileVC.canEditProfile = NO;
        
        [profileVC setHidesBottomBarWhenPushed:YES];
        
       // profileVC.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}



#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable
{
    PFQuery *query = [self getQueryForTable];
    
    if (self.objects.count == 0) {
        [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    }
    
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        query = [PFQuery queryWithClassName:@"no_class"];
    }
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellIdentifier = @"UserProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrUserTableViewCell class]]) {
        
        StringrUserTableViewCell * userProfileCell = (StringrUserTableViewCell *)cell;
        
        // Creates the path and image for a profile thumbnail
        StringrPathImageView *cellProfileImage = (StringrPathImageView *)[self.view viewWithTag:1];
        [cellProfileImage setImageToCirclePath];
        [cellProfileImage setPathColor:[UIColor darkGrayColor]];
        [cellProfileImage setPathWidth:1.0];

        [userProfileCell.ProfileThumbnailImageView setFile:[object objectForKey:kStringrUserProfilePictureThumbnailKey]];
        [userProfileCell.ProfileThumbnailImageView loadInBackgroundWithIndicator];

        [userProfileCell.profileUsernameLabel setText:[NSString stringWithFormat:@"@%@", [object objectForKey:kStringrUserUsernameCaseSensitive]]];
        [userProfileCell.profileDisplayNameLabel setText:[object objectForKey:kStringrUserDisplayNameKey]];
        
        PFQuery *numberOfStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
        [numberOfStringsQuery whereKey:kStringrStringUserKey equalTo:object];
        
        int numberOfStrings = [[object objectForKey:kStringrUserNumberOfStringsKey] intValue];
        
        [userProfileCell.profileNumberOfStringsLabel setText:[NSString stringWithFormat:@"%d", numberOfStrings]];
    }
 
    return cell;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
}

- (void)objectsWillLoad
{
    [super objectsWillLoad];
}

@end
