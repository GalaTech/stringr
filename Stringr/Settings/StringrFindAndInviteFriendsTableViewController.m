//
//  StringrFindAndInviteFriendsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFindAndInviteFriendsTableViewController.h"
#import "StringrFBFriendPickerViewController.h"
#import "StringrUserTableViewCell.h"
#import "StringrInviteUserTableViewCell.h"
#import "StringrProfileViewController.h"
#import "StringrPathImageView.h"
#import "UIImage+Resize.h"
#import "UIColor+StringrColors.h"

@interface StringrFindAndInviteFriendsTableViewController () <FBFriendPickerDelegate>

@property (strong, nonatomic) NSArray *friendUsers;
@property (strong, nonatomic) NSArray *facebookFriendsToInvite;

@property (strong, nonatomic) NSMutableData *profileImageData;
@property (strong, nonatomic) UIImage *userProfileImage;

@end

@implementation StringrFindAndInviteFriendsTableViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrUserClassKey;
        self.objectsPerPage = 10;
        self.paginationEnabled = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Find Friends";
    self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)findFacebookFriends
{
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            

            // result will contain an array with your user's friends in the "data" key
            NSMutableArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *friendUsers, NSError *error ) {
                if (!error) {
                    if (friendUsers && friendUsers.count > 0) {
                        
                        for (PFUser *friendUser in friendUsers) {
                            [friendObjects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger index, BOOL *stop) {
                                
                                if ([[obj objectForKey:@"id"] isEqualToString:[friendUser objectForKey:kStringrUserFacebookIDKey]]) {
                                    [friendObjects removeObjectAtIndex:index];
                                    return YES;
                                }
                                
                                return NO;
                            }];
                        }
                        
                        self.friendUsers = friendUsers;
                        
                        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                        self.facebookFriendsToInvite = [friendObjects sortedArrayUsingDescriptors:sortDescriptors];
                        
                        [self.tableView reloadData];
                    }
                }
            }];
        }
    }];
}



#pragma mark - PFQueryTableViewControllerDelegate

- (void)objectsWillLoad
{
    if ([[PFUser currentUser] objectForKey:kStringrUserFacebookIDKey]) {
        // I call this here because it is called when the controller is loaded.
        // It is also called when a user pulls to refresh.
        [self findFacebookFriends];
    } else if ([[PFUser currentUser] objectForKey:kStringrUserTwitterIDKey]) {
        NSLog(@"twitter friends");
    }
}



#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    
    if (indexPath.section == 0) {
        cellIdentifier = @"friendCellIdentifier";
        StringrUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [userCell.ProfileThumbnailImageView setImageToCirclePath];
        [userCell.ProfileThumbnailImageView setPathWidth:1.0f];
        [userCell.ProfileThumbnailImageView setPathColor:[UIColor darkGrayColor]];
        
        PFUser *friendUserForCell = [self.friendUsers objectAtIndex:indexPath.row];
        
        [friendUserForCell fetchIfNeededInBackgroundWithBlock:^(PFObject *friendUser, NSError *error) {
            NSString *friendUsername = [StringrUtility usernameFormattedWithMentionSymbol:[friendUser objectForKey:kStringrUserUsernameCaseSensitive]];
            [userCell.profileUsernameLabel setText:friendUsername];
            
            PFFile *friendUserProfileImageFile = [friendUser objectForKey:kStringrUserProfilePictureKey];
            [userCell.ProfileThumbnailImageView setFile:friendUserProfileImageFile];
            [userCell.ProfileThumbnailImageView loadInBackgroundWithIndicator];
            [userCell.profileDisplayNameLabel setText:[friendUser objectForKey:kStringrUserDisplayNameKey]];
            
            NSString *numberOfStringsLabel = [NSString stringWithFormat:@"%d", [[friendUser objectForKey:kStringrUserNumberOfStringsKey] intValue]];
            [userCell.profileNumberOfStringsLabel setText:numberOfStringsLabel];
        }];
        
        return userCell;
    }
    /*
    else if (indexPath.section == 1) {
        cellIdentifier = @"cellIdentifier";
        StringrInviteUserTableViewCell *inviteUserCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        NSDictionary *facebookFriendUser = [self.facebookFriendsToInvite objectAtIndex:indexPath.row];
        [inviteUserCell setUserToInviteDisplayName:[facebookFriendUser objectForKey:@"name"]];
        
        NSString *facebookID = facebookFriendUser[@"id"];
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small&return_ssl_resources=1", facebookID]];
        [inviteUserCell setUserToInviteProfileImageURL:pictureURL];
        
        return inviteUserCell;
    } 
     */
     else {
        return nil;
    }
}



#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PFUser *userForProfile = [self.friendUsers objectAtIndex:indexPath.row];
        
        if (userForProfile) {
            StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
            [profileVC setUserForProfile:userForProfile];
            [profileVC setProfileReturnState:ProfileBackReturnState];
            
            [self.navigationController pushViewController:profileVC animated:YES];
        }
    }
    /*
    else if (indexPath.section == 1) {
        
        StringrFBFriendPickerViewController *friendPickerVC = [[StringrFBFriendPickerViewController alloc] init];
        friendPickerVC.delegate = self;
        
        [self presentViewController:friendPickerVC animated:YES completion:nil];
        
    }
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 94.0f;
    }
    /*
    else if (indexPath.section == 1) {
        return 60.0f;
    }
    */
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 35.0f;
    }
    
    return 0.0f;
}
 

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35.0)];
        [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
        UILabel *headerSectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 16)];
        
        UIFont *headerSectionTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
        [headerSectionTitleLabel setFont:headerSectionTitleFont];
        [headerSectionTitleLabel setTextColor:[UIColor darkGrayColor]];
        [headerSectionTitleLabel setText:@"Invite Friends"];
        [headerView addSubview:headerSectionTitleLabel];
        
        return headerView;
    }
    
    return nil;
}
 */

@end
