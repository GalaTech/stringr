//
//  StringrProfileViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrProfileViewController.h"
#import "StringrUtility.h"

#import "StringrEditProfileViewController.h"

@interface StringrProfileViewController ()

@end

@implementation StringrProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Could potentiall use the title to state who's profile it is.
	//self.title = @"My Profile";
    
    // If the user is not supposed to be able to go back then we init with the menu item
    if (!self.canGoBack) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(showMenu)];
    }
    
    if (self.canEditProfile == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(beginEditingProfile)];
    }
}

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

- (void)beginEditingProfile
{
    StringrEditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:editProfileVC animated:YES];
}


@end
