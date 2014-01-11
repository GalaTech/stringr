//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrNavigationController.h"

@interface StringrDetailViewController ()

@end

@implementation StringrDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Detail View";
}

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
