//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrTempDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrNavigationController.h"
#import "StringrStringCommentsViewController.h"

@interface StringrTempDetailViewController ()

@end

@implementation StringrTempDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Detail View";
}




#pragma mark - IBActions

// Opens the profile for the uploader of the string, which this detail view is based around
- (IBAction)openUserProfile:(UIButton *)sender
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
 
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];

    profileVC.title = @"User Profile";
    
    profileVC.canGoBack = YES;
    profileVC.canEditProfile = NO;
    profileVC.canCloseModal = YES;

    profileVC.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:navVC animated:YES completion:nil];
}









@end
