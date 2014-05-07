//
//  StringrWriteAndEditTextViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrWriteAndEditTextViewController.h"

@interface StringrWriteAndEditTextViewController () <UIAlertViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *editableTextView;
@property (strong, nonatomic) NSString *editedText;

@end

@implementation StringrWriteAndEditTextViewController

#pragma mark - Lifecycle

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
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelText)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveText)];
    
    // prevents a post from being made. This is enabled to yes if a user types a character.
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    [self.editableTextView setText:self.editedText];
    
    [self.editableTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Custom Accessors


- (NSString *)editedText
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:_editedText]) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    return _editedText;
}


/*
- (void)setEditedText:(NSString *)editedText
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:_editedText]) {
        _editedText = editedText;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        _editedText = @"";
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}
 */




#pragma mark - Public

- (void)setTextForEditing:(NSString *)text
{
    self.editedText = text;
    self.editableTextView.text = text;
}





#pragma mark - Actions

- (void)saveText
{
    [self dismissViewControllerAnimated:YES completion: ^{
        
        if ([self.delegate respondsToSelector:@selector(reloadTextAtIndexPath:withText:)]) {
            NSIndexPath *textToReloadIndexPath = nil;
            if ([self.title isEqualToString:@"Edit Title"]) {
                textToReloadIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            } else if ([self.title isEqualToString:@"Edit Description"]) {
                textToReloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            }
            [self.delegate reloadTextAtIndexPath:textToReloadIndexPath withText:self.editedText];
        } else if ([self.delegate respondsToSelector:@selector(textWrittenAndSavedByUser:withType:)]) {
            if ([self.title isEqualToString:@"Change Email"]) {
                if ([StringrUtility NSStringIsValidEmail:self.editedText]) {
                    [self.delegate textWrittenAndSavedByUser:self.editedText withType:StringrWrittenTextTypeEmail];
                }
            } else if ([self.title isEqualToString:@"Change Password"]) {
                if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.editedText]) {
                    [self.delegate textWrittenAndSavedByUser:self.editedText withType:StringrWrittenTextTypePassword];
                }
            } else {
                if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.editedText]) {
                    [self.delegate textWrittenAndSavedByUser:self.editedText withType:StringrWrittenTextTypeStandard];
                }
            }
        }
    }];
}

- (void)cancelText
{
    UIAlertView *cancelCommentAlert = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure that you want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [cancelCommentAlert show];
}




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - UITextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textView.text]) {
        self.editedText = textView.text;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([StringrUtility NSStringContainsCharactersWithoutWhiteSpace:textView.text]) {
        self.editedText = textView.text;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}
@end
