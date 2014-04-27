//
//  StringrInviteFriendsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrInviteFriendsTableViewController.h"
#import "StringrFBFriendPickerViewController.h"

@interface StringrInviteFriendsTableViewController () <UIAlertViewDelegate>

@end

@implementation StringrInviteFriendsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Invite Friends";
        self.tableView.backgroundColor = [StringrConstants kStringTableViewBackgroundColor];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_identifier"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)connectOrDisconnectFromFacebookAtRow:(NSIndexPath *)indexPath
{
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self userFacebookLoginData];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    } else {
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[PFUser currentUser] setObject:@"" forKey:kStringrUserFacebookIDKey];
                [[PFUser currentUser] saveEventually];
                
                NSLog(@"The user is no longer associated with their Facebook account.");
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)userFacebookLoginData
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            // If it's a new user we go through the setup of loading all their facebook info
            if (facebookID) {
                [[PFUser currentUser] setObject:facebookID forKey:kStringrUserFacebookIDKey];
                [[PFUser currentUser] saveInBackground];
            }
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"]) {
            
            // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Invite Friends"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Invite Facebook Friends"];
        }
        
        UIFont *cellTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        [cell.textLabel setFont:cellTextFont];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}




#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Join Stringr!"] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:^{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    } else if (indexPath.row == 1) {
         if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
         StringrFBFriendPickerViewController *friendPickerVC = [[StringrFBFriendPickerViewController alloc] init];
         [self presentViewController:friendPickerVC animated:YES completion:nil];
         } else {
         UIAlertView *userNeedsToConnectWithFacebookAlert = [[UIAlertView alloc] initWithTitle:@"Can't Invite Friends" message:@"You must be connected with Facebook to invite your friends." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         
         [userNeedsToConnectWithFacebookAlert show];
         [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
         }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Connect to Facebook"]) {
        [self connectOrDisconnectFromFacebookAtRow:nil];
    }
}





@end
