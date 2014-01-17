//
//  StringrUserUniversityPeopleTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserUniversityPeopleTableViewController.h"
#import "StringrUtility.h"

@interface StringrUserUniversityPeopleTableViewController ()

@end

@implementation StringrUserUniversityPeopleTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"University People";
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}




#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}



@end
