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
@property (strong, nonatomic) NSMutableDictionary *comment;

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
        self.comment = [[NSMutableDictionary alloc] init];
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

- (void)setComment:(NSMutableDictionary *)comment
{
    _comment = comment;
    
    if ([_comment objectForKey:@"commentText"]) {
        [self.navigationItem.rightBarButtonItem setEnabled:!self.navigationItem.rightBarButtonItem.enabled];
    }
    
}


#pragma mark - Actions

- (void)postComment
{
    NSString *commentText = [[self.comment objectForKey:@"commentText"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (commentText) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [self.delegate pushSavedComment:self.comment];
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
    if (![[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self.comment setObject:textView.text forKey:@"commentText"];
        [self.comment setObject:@"Stringr Image" forKey:@"profileImage"];
        [self.comment setObject:@"Alonso Holmes" forKey:@"profileDisplayName"];
        [self.comment setObject:@"Now" forKey:@"uploadDate"];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self.comment setObject:textView.text forKey:@"commentText"];
        [self.comment setObject:@"Stringr Image" forKey:@"profileImage"];
        [self.comment setObject:@"Alonso Holmes" forKey:@"profileDisplayName"];
        [self.comment setObject:@"Now" forKey:@"uploadDate"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
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
