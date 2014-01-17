//
//  StringrSettingsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrSettingsViewController.h"
#import "StringrUtility.h"

@interface StringrSettingsViewController ()

@end

@implementation StringrSettingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
}




#pragma mark - Private

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

@end
