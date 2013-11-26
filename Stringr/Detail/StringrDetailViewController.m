//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrDetailViewController.h"
#import "StringrProfileViewController.h"

@interface StringrDetailViewController ()

@end

@implementation StringrDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Detail View";
	
}


- (IBAction)openUserProfile:(UIButton *)sender
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    
    profileVC.title = @"User Profile";
    
    profileVC.canGoBack = YES;
    profileVC.canEditProfile = NO;

    profileVC.view.backgroundColor = [UIColor blackColor];
    
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:profileVC animated:YES];
}







@end
