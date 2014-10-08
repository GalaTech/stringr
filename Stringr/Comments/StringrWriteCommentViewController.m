//
//  StringrWriteCommentViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/3/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrWriteCommentViewController.h"
#import "StringrNetworkTask+PushNotification.h"

@interface StringrWriteCommentViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) PFObject *comment;


@end

@implementation StringrWriteCommentViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Write Comment";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelComment)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postComment)];
    
    // prevents a post from being made. This is enabled to yes if a user types a character.
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    
    
    
    if (!self.comment) {
        self.comment = [PFObject objectWithClassName:kStringrActivityClassKey];
        [self.comment setObject:kStringrActivityTypeComment forKey:kStringrActivityTypeKey];
        
        NSString *forObjectKey = kStringrActivityStringKey;
        NSString *forObjectUserKey = kStringrStringUserKey;
        
        if ([self.objectToCommentOn.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            forObjectKey = kStringrActivityPhotoKey;
            forObjectUserKey = kStringrPhotoUserKey;
        }
        
        [self.comment setObject:self.objectToCommentOn forKey:forObjectKey];
        [self.comment setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
        [self.comment setObject:[self.objectToCommentOn objectForKey:forObjectUserKey] forKey:kStringrActivityToUserKey];
    }
    
    PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    // allows the original owner of the string/photo being commented on to edit the posted comment.
    if ([StringrUtility objectIsString:self.objectToCommentOn]) {
        [commentACL setWriteAccess:YES forUser:[self.objectToCommentOn objectForKey:kStringrStringUserKey]];
    } else {
        [commentACL setWriteAccess:YES forUser:[self.objectToCommentOn objectForKey:kStringrPhotoUserKey]];
    }
    
    [commentACL setPublicReadAccess:YES];
    [self.comment setACL:commentACL];
    
    // Automatically displays the keyboard
    [self.commentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//*********************************************************************************/
#pragma mark - Custom Accessors
//*********************************************************************************/

- (PFObject *)comment
{
    if ([_comment objectForKey:kStringrActivityContentKey]) {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    return _comment;
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (void)sendCommentPushNotification
{
    // TODO: Set private channel to that of the photo uploader
    NSString *photoUploaderPrivatePushChannel;
    NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
  
    // String with the commenters name and the comment
    NSString *alert = [NSString stringWithFormat:@"%@: %@", currentUsernameFormatted, [self.comment objectForKey:kStringrActivityContentKey]];
    
    // make sure to leave enough space for payload overhead
    if (alert.length > 100) {
        alert = [alert substringToIndex:89];
        alert = [alert stringByAppendingString:@"…"];
    }
    
    if (![[[self.objectToCommentOn objectForKey:kStringrStringUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && [StringrUtility objectIsString:self.objectToCommentOn]) {
        
        photoUploaderPrivatePushChannel = [[self.objectToCommentOn objectForKey:kStringrStringUserKey] objectForKey:kStringrUserPrivateChannelKey];
        
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"Increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [self.objectToCommentOn objectId], kStringrPushPayloadStringObjectIDKey,
                                  @"default", kAPNSSoundKey,
                                  nil];
            
            
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    }
    else if (![[[self.objectToCommentOn objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && ![StringrUtility objectIsString:self.objectToCommentOn]) {
       
        photoUploaderPrivatePushChannel = [[self.objectToCommentOn objectForKey:kStringrPhotoUserKey] objectForKey:kStringrUserPrivateChannelKey];
        
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"Increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [self.objectToCommentOn objectId], kStringrPushPayloadPhotoObjectIdKey,
                                  @"default", kAPNSSoundKey,
                                  nil];
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    }
}

- (void)findAndSendNotificationToMentionsInComment:(PFObject *)objectForComment
{
    // Extracts all of the @mentions from the title and description of the comment
    NSArray *commentMentions = [StringrUtility mentionsContainedWithinString:[self.comment objectForKey:kStringrActivityContentKey]];
    
    // Finds all users whose username matches these mentions.
    PFQuery *mentionUsersQuery = [PFUser query];
    [mentionUsersQuery whereKey:kStringrUserUsernameKey containedIn:commentMentions];
    [mentionUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (!error) {
            
            // Create a new mention activity for all users who were mentioned in the comment
            for (PFUser *user in users) {
                if (![user.objectId isEqualToString:[PFUser currentUser].objectId]){
                    PFObject *mentionActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
                    [mentionActivity setObject:kStringrActivityTypeMention forKey:kStringrActivityTypeKey];
                    [mentionActivity setObject:kStringrActivityContentCommentKey forKey:kStringrActivityContentKey];
                    [mentionActivity setObject:user forKey:kStringrActivityToUserKey];
                    [mentionActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
                    
                    if ([StringrUtility objectIsString:objectForComment]) {
                        [mentionActivity setObject:objectForComment forKey:kStringrActivityStringKey];
                    } else {
                        [mentionActivity setObject:objectForComment forKey:kStringrActivityPhotoKey];
                    }
                    
                    PFACL *mentionACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [mentionACL setPublicReadAccess:YES];
                    [mentionACL setPublicWriteAccess:YES];
                    [mentionActivity setACL:mentionACL];
                    
                    [mentionActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [StringrNetworkTask sendMentionPushNotificationToUser:user withObject:self.comment];
                    }];
                }
            }
        }
    }];
}



//*********************************************************************************/
#pragma mark - Actions
//*********************************************************************************/

- (void)postComment
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:[self.comment objectForKey:kStringrActivityContentKey]]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    if ([self.delegate respondsToSelector:@selector(commentViewController:didPostComment:)]) {
                        [self.delegate commentViewController:self didPostComment:self.comment];
                    }
                    
                    [StringrNetworkTask sendCommentPushNotification:self.objectToCommentOn comment:self.comment];
                } else if (error && error.code == kPFErrorObjectNotFound) {
                    [[StringrCache sharedCache] decrementCommentCountForObject:self.objectToCommentOn];
                }
            }];
            
            [[StringrCache sharedCache] incrementCommentCountForObject:self.objectToCommentOn];
            
            if ([StringrUtility objectIsString:self.objectToCommentOn]) {
                PFQuery *statisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
                [statisticsQuery whereKey:kStringrStatisticsStringKey equalTo:self.objectToCommentOn];
                [statisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *strings, NSError *error) {
                    if (!error) {
                        PFObject *stringStatistics = [strings firstObject];
                        [stringStatistics incrementKey:kStringrStatisticsCommentCountKey];
                        [stringStatistics saveEventually];
                    }
                }];
            }
            
            [self findAndSendNotificationToMentionsInComment:self.objectToCommentOn];
        }];
    }
}

- (void)cancelComment
{
    UIAlertView *cancelCommentAlert = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure that you don't want to write a comment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [cancelCommentAlert show];
}



//*********************************************************************************/
#pragma mark - UITextView Delegate
//*********************************************************************************/

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textView.text]) {
        [self.comment setObject:textView.text forKey:kStringrActivityContentKey];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textView.text]) {
        [self.comment setObject:textView.text forKey:kStringrActivityContentKey];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}



//*********************************************************************************/
#pragma mark - UIAlertView Delegate
//*********************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(commentViewControllerDidCancel:)]) {
            [self.delegate commentViewControllerDidCancel:self];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
