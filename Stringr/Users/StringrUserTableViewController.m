//
//  StringrUserTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewController.h"
#import "StringrProfileViewController.h"

@interface StringrUserTableViewController ()

@end

@implementation StringrUserTableViewController



- (IBAction)openUserProfile:(UIButton *)sender
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    
    profileVC.title = sender.currentTitle;
    
    profileVC.canGoBack = YES;
    profileVC.canEditProfile = NO;
    
    profileVC.view.backgroundColor = [UIColor blackColor];
    
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:profileVC animated:YES];
}



@end
