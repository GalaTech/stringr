//
//  StringrSettingsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrSettingsTableViewController.h"
#import "StringrNavigationController.h"
#import "StringrLoginViewController.h"
#import "StringrUtility.h"
#import "StringrRootviewController.h"
#import "StringrFindAndInviteFriendsTableViewController.h"
#import "StringrPrivacyPolicyTermsOfServiceViewController.h"
#import "StringrFBFriendPickerViewController.h"
#import "StringrWriteAndEditTextViewController.h"
#import "StringrInviteFriendsTableViewController.h"
#import "StringrPushNotificationsTableViewController.h"
#import "StringrStringDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "PBWebViewController.h"
#import "ZCImagePickerController.h"


@interface StringrSettingsTableViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, StringrWriteAndEditTextViewControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZCImagePickerControllerDelegate>

@end

@implementation StringrSettingsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
	self.tableView.backgroundColor = [StringrConstants kStringTableViewBackgroundColor];
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterUploadNewStringKey object:nil];
}

- (void)dealloc
{
    NSLog(@"dealloc settings");
}



#pragma mark - Private

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

- (void)composeSupportEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *supportEmail = [[MFMailComposeViewController alloc] init];
        supportEmail.mailComposeDelegate = self;
        [supportEmail setToRecipients:@[@"support@stringrapp.com"]];
        [supportEmail setSubject:@"Bug report for Stringr"];
        
        [self presentViewController:supportEmail animated:YES completion:nil];
    } else {
        
    }
}

- (void)presentPrivacyPolicy
{
    /*
    // Initialize the web view controller and set it's URL
    self.webViewController = [[PBWebViewController alloc] init];
    self.webViewController.URL = [NSURL URLWithString:@"http://www.apple.com"];
    
    // These are custom UIActivity subclasses that will show up in the UIActivityViewController
    // when the action button is clicked
    PBSafariActivity *activity = [[PBSafariActivity alloc] init];
    self.webViewController.applicationActivities = @[activity];
    
    // This property also corresponds to the same one on UIActivityViewController
    // Both properties do not need to be set unless you want custom actions
    self.webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    // Push it
    [self.navigationController pushViewController:self.webViewController animated:YES];
     */
    
    PBWebViewController *privacyPolicyWebVC = [[PBWebViewController alloc] init];
    [privacyPolicyWebVC setURL:[NSURL URLWithString:@"https://www.facebook.com/about/privacy/your-info"]];

    [self.navigationController pushViewController:privacyPolicyWebVC animated:YES];
    
    /*
    
    StringrPrivacyPolicyTermsOfServiceViewController *privacyPolicyVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPrivacyPolicyToSID];
    [privacyPolicyVC setIsPrivacyPolicy:YES];
    UIBarButtonItem *privacyBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:privacyBarButtonItem];
    
    [self.navigationController pushViewController:privacyPolicyVC animated:YES];
     */
}

- (void)presentTermsOfService
{
    PBWebViewController *privacyPolicyWebVC = [[PBWebViewController alloc] init];
    [privacyPolicyWebVC setURL:[NSURL URLWithString:@"https://www.facebook.com/legal/terms"]];
    
    [self.navigationController pushViewController:privacyPolicyWebVC animated:YES];
    
    /*
    StringrPrivacyPolicyTermsOfServiceViewController *privacyPolicyVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPrivacyPolicyToSID];
    [privacyPolicyVC setIsPrivacyPolicy:NO];
    UIBarButtonItem *privacyBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:privacyBarButtonItem];
    
    [self.navigationController pushViewController:privacyPolicyVC animated:YES];
     */
}

- (void)connectOrDisconnectFromTwitterAtRow:(NSIndexPath *)indexPath
{
    if (![PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
                    [self userTwitterLoginData];
                }
            }
        }];
    } else {
        [PFTwitterUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[PFUser currentUser] setObject:@"" forKey:kStringrUserTwitterIDKey];
                [[PFUser currentUser] saveEventually];
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)userTwitterLoginData
{
    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (userData) {
        
        NSString *twitterID = [userData objectForKey:@"id"];
        if (twitterID) {
            [[PFUser currentUser] setObject:twitterID forKey:kStringrUserTwitterIDKey];
            [[PFUser currentUser] saveEventually];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            /*
        case 1:
            return 2;
            break;
             */
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIFont *cellTextLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [cell.textLabel setFont:cellTextLabelFont];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    
    if (cell) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"Find Facebook Friends to Follow"];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Invite Friends"];
                }
                break;
                // connect/disconnect from facebook/twitter and change email/password
           /*
            case 1:
//                if (indexPath.row == 0) {
//                    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//                        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
//                        [cell.textLabel setText:@"Disconnect from Facebook"];
//                    } else {
//                        UIColor *facebookBlue = [UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0];
//                        [cell.textLabel setTextColor:facebookBlue];
//                        [cell.textLabel setText:@"Connect with Facebook"];
//                    }
//                } else if (indexPath.row == 1) {
//                    if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
//                        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
//                        [cell.textLabel setText:@"Disconnect from Twitter"];
//                    } else {
//                        UIColor *twitterBlue = [UIColor colorWithRed:64/255.0f green:153/255.0f blue:255/255.0f alpha:1.0];
//                        [cell.textLabel setTextColor:twitterBlue];
//                        [cell.textLabel setText:@"Connect with Twitter"];
//                    }
//                } else
                
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"Change Account Email"];
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Change Account Password"];
                }
                break;
                */
            case 1:
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"Report a Problem"];
                }
                /*
                else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Stringr Help Center"];
                } 
                 */
                 else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Privacy Policy"];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"Terms of Service"];
                }
                /*
                else if (indexPath.row == 4) {
                    [cell.textLabel setText:@"About This Version"];
                }
                 */
                break;
            case 2:
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"Push Notification Settings"];
                }
                break;
            case 3:
                if (indexPath.row == 0) {
                    UIColor *redColor = [UIColor colorWithRed:204.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
                    [cell.textLabel setText:@"Log Out"];
                    [cell.textLabel setTextColor:redColor];
                }
                break;
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
                StringrFindAndInviteFriendsTableViewController *findFriendsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardFindAndInviteFriendsID];
                [self.navigationController pushViewController:findFriendsVC animated:YES];
            } else {
                UIAlertView *userNeedsToConnectWithFacebookAlert = [[UIAlertView alloc] initWithTitle:@"Can't Find Friends" message:@"You must be connected with Facebook to find your friends." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [userNeedsToConnectWithFacebookAlert show];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else if (indexPath.row == 1) {
            
            StringrInviteFriendsTableViewController *inviteFriendsTableVC = [[StringrInviteFriendsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:inviteFriendsTableVC animated:YES];
        
        }
    }
    /*
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            StringrWriteAndEditTextViewController *changeEmailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardWriteAndEditID];
            changeEmailVC.title = @"Change Email";
            
            [changeEmailVC setTextForEditing:[[PFUser currentUser] email]];
            changeEmailVC.delegate = self;
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:changeEmailVC];
            [self presentViewController:navVC animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            StringrWriteAndEditTextViewController *changePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardWriteAndEditID];
            changePasswordVC.title = @"Change Password";
            changePasswordVC.delegate = self;
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:changePasswordVC];
            [self presentViewController:navVC animated:YES completion:nil];
        }
    } 
     */
     else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self composeSupportEmail];
        } else if (indexPath.row ==1) {
            [self presentPrivacyPolicy];
        } else if (indexPath.row == 2) {
            [self presentTermsOfService];
        }
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        StringrPushNotificationsTableViewController *pushNotificationsVC = [[StringrPushNotificationsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:pushNotificationsVC animated:YES];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        [PFQuery clearAllCachedResults];
        [[StringrCache sharedCache] clear];
        
        // Unsubscribe from push notifications for this installation
        [[PFInstallation currentInstallation] removeObjectForKey:kStringrInstallationUserKey];
        [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey] forKey:kStringrInstallationPrivateChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
        
        [PFUser logOut];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // I needed to get the direct root view controller in order to present a VC.
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        StringrRootViewController *rootVC = (StringrRootViewController *)[window rootViewController];
        
        AppDelegate *stringrAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        StringrLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardLoginID];
        [loginVC setDelegate:stringrAppDelegate];
        
        StringrNavigationController *loginNavVC = [[StringrNavigationController alloc] initWithRootViewController:loginVC];
        
        [rootVC presentViewController:loginNavVC animated:YES completion:^{
            
            // forces the main content area to be blank with no content. That way if a user logs
            // back in we can easily reinstantiate the content area without any data remaining from the previous
            // user
            UIViewController *blankVC = [[UIViewController alloc] init];
            [self.frostedViewController setContentViewController:blankVC];
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35.0)];
    [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UILabel *headerSectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 16)];
    
    UIFont *headerSectionTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
    [headerSectionTitleLabel setFont:headerSectionTitleFont];
    [headerSectionTitleLabel setTextColor:[UIColor darkGrayColor]];
    
    switch (section) {
        case 1:
            headerSectionTitleLabel.text = @"Account";
            break;
        case 2:
            headerSectionTitleLabel.text = @"Support";
            break;
        case 3:
            headerSectionTitleLabel.text = @"Preferences";
            break;
            
        default:
            headerSectionTitleLabel.text = @"";
            break;
    }
    
    [headerView addSubview:headerSectionTitleLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // maybe report different successes of result: cancelled, sent, failed, etc.
    [self dismissViewControllerAnimated:YES completion:nil];
}






#pragma mark - StringrWriteAndEditViewControllerDelegate

- (void)textWrittenAndSavedByUser:(NSString *)text withType:(StringrWrittenTextType)textType
{
    if (textType == StringrWrittenTextTypeEmail) {
        [PFUser currentUser].email = text;
    } else if (textType == StringrWrittenTextTypePassword) {
        [PFUser currentUser].password = text;
    } else {
        return;
    }
    
    [[PFUser currentUser] saveEventually];
}



- (void)addNewString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Create New String"
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
    
    [newStringActionSheet addButtonWithTitle:@"Take Photo"];
    [newStringActionSheet addButtonWithTitle:@"Choose from Existing"];
    
    /* Implement return to saved string
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     if (![defaults objectForKey:kUserDefaultsWorkingStringSavedImagesKey]) {
     [newStringActionSheet addButtonWithTitle:@"Return to Saved String"];
     [newStringActionSheet setDestructiveButtonIndex:[newStringActionSheet numberOfButtons] - 1];
     }
     */
    
    [newStringActionSheet addButtonWithTitle:@"Cancel"];
    [newStringActionSheet setCancelButtonIndex:[newStringActionSheet numberOfButtons] - 1];
    
    
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [newStringActionSheet showInView:self.view];
    } else {
        [newStringActionSheet showInView:window];
    }
    
}




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    } else if (buttonIndex == 0) {
        
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
        imagePickerController.imagePickerDelegate = self;
        imagePickerController.maximumAllowsSelectionCount = 10;
        imagePickerController.mediaType = ZCMediaAllPhotos;
        [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 2) { // supposed to be for returning to saved string
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
}




#pragma mark - UIImagePicker Delegate

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setStringToLoad:nil]; // set to nil because we don't have a string yet.
        [newStringVC setEditDetailsEnabled:YES];
        [newStringVC setUserSelectedPhoto:image];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}




#pragma mark - ZCImagePickerController Delegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDict in info) {
        UIImage *image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        
        [images addObject:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setStringToLoad:nil]; // set to nil because we don't have a string yet.
        [newStringVC setEditDetailsEnabled:YES];
        
        if (images.count <= 1) {
            [newStringVC setUserSelectedPhoto:images[0]];
        } else {
            [newStringVC setUserSelectedPhotos:images];
        }
        
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}

- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
