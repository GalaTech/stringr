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
        [self.objectToCommentOn incrementKey:kStringrStringNumberOfCommentsKey];
        
        if ([self.objectToCommentOn.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            [self.objectToCommentOn incrementKey:kStringrPhotoNumberOfCommentsKey];
            forObjectKey = kStringrActivityPhotoKey;
            forObjectUserKey = kStringrPhotoUserKey;
        }
        
        [self.comment setObject:self.objectToCommentOn forKey:forObjectKey];
        [self.comment setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
        [self.comment setObject:[self.objectToCommentOn objectForKey:forObjectUserKey] forKey:kStringrActivityToUserKey];
    }
    
    // Automatically displays the keyboard
    [self.commentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Custom Accessors

/*
- (void)setComment:(PFObject *)comment
{
    _comment = comment;
    
    if ([_comment objectForKey:kStringrActivityContentKey]) {
        [self.navigationItem.rightBarButtonItem setEnabled:!self.navigationItem.rightBarButtonItem.enabled];
    }
    
}
 */

- (PFObject *)comment
{
    if ([_comment objectForKey:kStringrActivityContentKey]) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    return _comment;
}


#pragma mark - Actions

- (void)postComment
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:[self.comment objectForKey:kStringrActivityContentKey]]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.objectToCommentOn saveInBackground];
                    [self.delegate reloadCommentTableView];
                }
            }];
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
