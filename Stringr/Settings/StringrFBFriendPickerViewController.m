//
//  StringrFBFriendPickerViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFBFriendPickerViewController.h"

@interface StringrFBFriendPickerViewController () <FBFriendPickerDelegate>

@end

@implementation StringrFBFriendPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Invite Friends";
    self.allowsMultipleSelection = YES;
    self.itemPicturesEnabled = YES;
    self.delegate = self;
    [self clearSelection];
    [self loadData];
    
    
    UIBarButtonItem *closeModalButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(closeModal)];
    closeModalButton.tintColor = [UIColor grayColor];
    self.cancelButton = closeModalButton;
    
    UIBarButtonItem *inviteFriendsButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteSelectedFriends)];
    inviteFriendsButton.tintColor = [UIColor grayColor];
    inviteFriendsButton.enabled = NO;
    self.doneButton = inviteFriendsButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteSelectedFriends
{
    NSArray *friendArray = self.selection;
    
    if (friendArray.count > 0) {
        NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
        
        for (int i = 0; i < friendArray.count; i++) {
            NSString *friendID = friendArray[i][@"id"];
            [params setObject:friendID forKey:[NSString stringWithFormat:@"to[%d]", i]];
        }
        
        // presents the modal facebook request view that will contain
        [FBWebDialogs presentRequestsDialogModallyWithSession:FBSession.activeSession
                                                      message:[NSString stringWithFormat:@"Come and check out the greatest app!"]
                                                        title:@"Stringr"
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // Case A: Error launching the dialog or sending request.
                                                              NSLog(@"Error sending request.");
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // Case B: User clicked the "x" icon
                                                                  NSLog(@"User canceled request.");
                                                              } else if([[resultURL description] hasPrefix:@"fbconnect://success?request="]) { // if the user presses the send button
                                                                  NSLog(@"Request Sent.");
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                              } else {
                                                                 
                                                              }
                                                          }}
                                                  friendCache:nil];
    }
    
}




#pragma mark - FB Friend Picker Delegate

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    if (self.selection.count > 0) {
        [self.doneButton setEnabled:YES];
    } else {
        [self.doneButton setEnabled:NO];
    }
}




@end
