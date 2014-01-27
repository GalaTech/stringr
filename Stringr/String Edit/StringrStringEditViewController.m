//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringEditViewController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrStringEditTableViewController.h"
#import "StringrStringTopEditViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

@interface StringrStringEditViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation StringrStringEditViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Publish String";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(saveAndPublishString)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(returnToPreviousScreen)];

    StringrStringTopEditViewController *topEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editStringTopVC"];
    StringrStringEditTableViewController *tableEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editStringTableVC"];
    self.delegate = self;
    
    [self setupWithTopViewController:topEditVC andTopHeight:283 andBottomViewController:tableEditVC];
    
    
    self.maxHeightBorder = CGRectGetHeight(self.view.frame);
    [self enableTapGestureTopView:NO];
    
    [self.view setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    StringrStringEditTableViewController *tableVC = (StringrStringEditTableViewController *)self.bottomViewController;
    
    [tableVC setStringTitle:@"Hello!"];
    //[tableVC.stringTitleTextField setDelegate:self];
    
    
    // Adds observer's for different actions that can be performed by selecting different UIObject's on screen
    NSLog(@"Added observers from viewWillAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfileImage:) name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCommentsButton:) name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectLikesButton:) name:@"didSelectLikesButton" object:nil];
    
    // Adds notifications to know when the keyboard is shown and hidden
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"Removed observers from view disappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
}






#pragma mark - Actions

- (void)saveAndPublishString
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserDefaultsWorkingStringSavedImagesKey];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)returnToPreviousScreen
{
    UIAlertView *cancelStringAlert = [[UIAlertView alloc] initWithTitle:@"Cancel String"
                                                                message:@"Are you sure that you want to cancel?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", @"Save for later", nil];
    [cancelStringAlert show];
}

#pragma mark - NSNotificationCenter Handlers

// Handles the action of pushing to a selected user's profile
- (void)didSelectProfileImage:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
    NSLog(@"Removed observers from selecting profile");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
    
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    [profileVC setCanGoBack:YES];
    [profileVC setCanEditProfile:NO];
    [profileVC setTitle:@"User Profile"];
    //[profileVC setCanCloseModal:YES];
    
    [profileVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:profileVC animated:YES];
    
    //Implements modal transition to profile view
    //StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    //[self presentViewController:navVC animated:YES completion:nil];
}

// Handles the action of pushing to the comment's of a selected string
- (void)didSelectCommentsButton:(NSNotification *)notification
{
    StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringCommentsVC"];
    
    [self.navigationController pushViewController:commentsVC animated:YES];
}

// Handles the action of liking the selected string
- (void)didSelectLikesButton:(NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked String"
                                                    message:@"You have liked this String!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

/*
- (void)keyboardWillShow:(NSNotification *)note {
    // Gets the rect of the keyboard
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Gets the size of the scroll view
    CGSize scrollViewContentSize = self.parallaxScrollView.bounds.size;
    
    // Sets the height of our CG size to add the height of the keyboard
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    
    // Sets the content size of the scroll view to our newly created CGSize
    //[self.parallaxScrollView setContentSize:scrollViewContentSize];
    
    // Creates a point to move the scroll view to adjust for the keyboard.
    CGPoint scrollViewContentOffset = self.parallaxScrollView.contentOffset;
    scrollViewContentOffset.y += keyboardFrameEnd.size.height;
    scrollViewContentOffset.y -= 65.0f;
    
    // Moves the scroll view to the new content offset in an animated fashion.
    [self.parallaxScrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.parallaxScrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.parallaxScrollView setContentSize:scrollViewContentSize];
    }];
}
//*/




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:kUserDefaultsWorkingStringSavedImagesKey];
        [defaults synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else if (buttonIndex == 2) {
        // Set the delegate to parentViewController so that it will properly be handled after the navigation has moved back to that VC
        UIAlertView *stringSavedAlert = [[UIAlertView alloc] initWithTitle:@"String Saved!" message:@"Your string has been saved for future editing." delegate:self.parentViewController cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [stringSavedAlert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
