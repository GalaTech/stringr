//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailViewController.h"
//#import "StringrDiscoveryTabBarViewController.h"
#import "StringrStringDetailTableViewController.h"
#import "StringrStringDetailTopViewController.h"
#import "StringrStringDetailEditTopViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

@interface StringrStringDetailViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) StringrStringDetailTopViewController *stringTopVC;
@property (strong, nonatomic) StringrStringDetailTableViewController *stringTableVC;

@end

@implementation StringrStringDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stringTopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailTopVC"];
    [self.stringTopVC setStringToLoad:self.stringToLoad];
    
    self.stringTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailTableVC"];
    [self.stringTableVC setStringDetailsToLoad:self.stringToLoad];
    
    
    if (self.editDetailsEnabled) {
        self.title = @"Publish String";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(saveAndPublishString)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                     style:UIBarButtonItemStyleBordered
                                                                                    target:self
                                                                                    action:@selector(returnToPreviousScreen)];
        
        
        // notice that there is explicit casting for these classes.
        self.stringTopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailEditTopVC"];
        [(StringrStringDetailEditTopViewController *)self.stringTopVC setUserSelectedPhoto:self.userSelectedPhoto];
        [(StringrStringDetailEditTopViewController *)self.stringTopVC setStringToLoad:self.stringToLoad];
        
        self.stringTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailEditTableVC"];
        [self.stringTableVC setStringDetailsToLoad:self.stringToLoad];
        [self.stringTableVC setEditDetailsEnabled:YES];
        [(StringrStringDetailEditTableViewController *)self.stringTableVC setDelegate:(StringrStringDetailEditTopViewController *)self.stringTopVC];
    } else {
        self.title = @"String Details";
    }
    
    
    [self setupWithTopViewController:self.stringTopVC andTopHeight:283 andBottomViewController:self.stringTableVC];
    
    self.maxHeightBorder = CGRectGetHeight(self.view.frame);
    [self enableTapGestureTopView:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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