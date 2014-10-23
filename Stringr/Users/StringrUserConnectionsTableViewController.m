//
//  StringrUserConnectionsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserConnectionsTableViewController.h"
#import "StringrProfileViewController.h"
#import "StringrUserTableViewCell.h"
#import "StringrPathImageView.h"
#import "UIColor+StringrColors.h"

@interface StringrUserConnectionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *connectionUsers;

@end

@implementation StringrUserConnectionsTableViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrUserClassKey;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
    
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (void)queryForFollowingUsers
{
    PFQuery *followingUserActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followingUserActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followingUserActivityQuery whereKey:kStringrActivityFromUserKey equalTo:self.userForConnections];
    [followingUserActivityQuery setLimit:1000];
    [followingUserActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                self.connectionUsers = [[NSMutableArray alloc] initWithCapacity:objects.count];
                for (PFObject *activityObject in objects) {
                    
                    [self.connectionUsers addObject:[activityObject objectForKey:kStringrActivityToUserKey]];
                }
                
                [self.tableView reloadData];
            } else {
                NSString *currentUserProfileName = [self.userForConnections objectForKey:kStringrUserUsernameCaseSensitive];
                NSString *usernameWithMention = [StringrUtility usernameFormattedWithMentionSymbol:currentUserProfileName];
                StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:[NSString stringWithFormat:@"%@ is not following any users", usernameWithMention]];
                [noContentHeaderView setDelegate:self];
                
                self.tableView.tableHeaderView = noContentHeaderView;
            }
        }
    }];
}

- (void)queryForFollowerUsers
{
    PFQuery *followersUserActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [followersUserActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeFollow];
    [followersUserActivityQuery whereKey:kStringrActivityToUserKey equalTo:self.userForConnections];
    [followersUserActivityQuery setLimit:1000];
    [followersUserActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                self.connectionUsers = [[NSMutableArray alloc] initWithCapacity:objects.count];
                for (PFObject *activityObject in objects) {
                    
                    [self.connectionUsers addObject:[activityObject objectForKey:kStringrActivityFromUserKey]];
                }
                
                [self.tableView reloadData];
            } else {
                NSString *currentUserProfileName = [self.userForConnections objectForKey:kStringrUserUsernameCaseSensitive];
                NSString *usernameWithMention = [StringrUtility usernameFormattedWithMentionSymbol:currentUserProfileName];
                StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithFrame:CGRectMake(0, 0, 640, 200) andNoContentText:[NSString stringWithFormat:@"%@ does not have any followers", usernameWithMention]];
                [noContentHeaderView setDelegate:self];
                
                self.tableView.tableHeaderView = noContentHeaderView;
            }
        }
    }];
}



//*********************************************************************************/
#pragma mark - UITableView Data Source
//*********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.connectionUsers.count;
}

- (void)objectsWillLoad
{
    if (self.connectionType == UserConnectionFollowingType){
        [self queryForFollowingUsers];
    } else if (self.connectionType == UserConnectionFollowersType) {
        [self queryForFollowerUsers];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrUserTableViewCell class]]) {
        
        StringrUserTableViewCell * userProfileCell = (StringrUserTableViewCell *)cell;
        
        [userProfileCell.ProfileThumbnailImageView setImageToCirclePath];
        [userProfileCell.ProfileThumbnailImageView setPathWidth:1.0f];
        [userProfileCell.ProfileThumbnailImageView setPathColor:[UIColor darkGrayColor]];

        PFUser *userForCell = [self.connectionUsers objectAtIndex:indexPath.row];
        [userForCell fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                [userProfileCell.profileUsernameLabel setText:[NSString stringWithFormat:@"@%@", [user objectForKey:kStringrUserUsernameCaseSensitive]]];
                [userProfileCell.profileDisplayNameLabel setText:[user objectForKey:kStringrUserDisplayNameKey]];
                
                [userProfileCell.ProfileThumbnailImageView setFile:[user objectForKey:kStringrUserProfilePictureThumbnailKey]];
                [userProfileCell.ProfileThumbnailImageView loadInBackgroundWithIndicator];
                
                int numberOfStrings = [[user objectForKey:kStringrUserNumberOfStringsKey] intValue];
                [userProfileCell.profileNumberOfStringsLabel setText:[NSString stringWithFormat:@"%d", numberOfStrings]];
            }
        }];
    }
    
    return cell;
}



//*********************************************************************************/
#pragma mark - UITableView Delegate
//*********************************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *userAtIndex = [self.connectionUsers objectAtIndex:indexPath.row];
    
    if (userAtIndex) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        [profileVC setUserForProfile:userAtIndex];
        [profileVC setProfileReturnState:ProfileBackReturnState];
            
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
