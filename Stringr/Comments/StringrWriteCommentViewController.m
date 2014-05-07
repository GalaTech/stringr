//
//  StringrWriteCommentViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/3/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrWriteCommentViewController.h"

@interface StringrWriteCommentViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) PFObject *comment;


@end

@implementation StringrWriteCommentViewController

#pragma mark - Lifecycle

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
        //[self.objectToCommentOn incrementKey:kStringrStringNumberOfCommentsKey]; // cant save to a string or photo that will be read only...
        
        if ([self.objectToCommentOn.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            //[self.objectToCommentOn incrementKey:kStringrPhotoNumberOfCommentsKey]; // can't save to a string or photo that will be read only...
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




#pragma mark - Custom Accessors

- (PFObject *)comment
{
    if ([_comment objectForKey:kStringrActivityContentKey]) {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    return _comment;
}



#pragma mark - Private

- (void)sendCommentPushNotification
{
    // TODO: Set private channel to that of the photo uploader
    NSString *photoUploaderPrivatePushChannel = @"user_4Lr24ej01N";
    NSString *currentUsernameFormatted = [StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]];
  
    // String with the commenters name and the comment
    NSString *alert = [NSString stringWithFormat:@"%@: %@", currentUsernameFormatted, [self.comment objectForKey:kStringrActivityContentKey]];
    
    // make sure to leave enough space for payload overhead
    if (alert.length > 100) {
        alert = [alert substringToIndex:89];
        alert = [alert stringByAppendingString:@"…"];
    }
    
    if (![[[self.objectToCommentOn objectForKey:kStringrStringUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && [StringrUtility objectIsString:self.objectToCommentOn]) {
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [self.objectToCommentOn objectId], kStringrPushPayloadStringObjectIDKey,
                                  nil];
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    } else if (![[[self.objectToCommentOn objectForKey:kStringrPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]] && ![StringrUtility objectIsString:self.objectToCommentOn]) {
        if (photoUploaderPrivatePushChannel && photoUploaderPrivatePushChannel.length != 0) {
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, kAPNSAlertKey,
                                  @"increment", kAPNSBadgeKey,
                                  kStringrPushPayloadPayloadTypeActivityKey, kStringrPushPayloadPayloadTypeKey,
                                  kStringrPushPayloadActivityCommentKey, kStringrPushPayloadActivityTypeKey,
                                  [[PFUser currentUser] objectId], kStringrPushPayloadFromUserObjectIdKey,
                                  [self.objectToCommentOn objectId], kStringrPushPayloadPhotoObjectIdKey,
                                  nil];
            
            PFPush *likePhotoPushNotification = [[PFPush alloc] init];
            [likePhotoPushNotification setChannel:photoUploaderPrivatePushChannel];
            [likePhotoPushNotification setData:data];
            [likePhotoPushNotification sendPushInBackground];
        }
    }
}



#pragma mark - Actions

- (void)postComment
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:[self.comment objectForKey:kStringrActivityContentKey]]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self.objectToCommentOn saveInBackground]; // save to incrememnt comment count // can't save to a string/photo that is read only...
                    [self.delegate reloadCommentTableView];
                    [self sendCommentPushNotification];
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
        }];
    }
}

- (void)cancelComment
{
    UIAlertView *cancelCommentAlert = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure that you don't want to write a comment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [cancelCommentAlert show];
}



#pragma mark - UITextView Delegate


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



#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
