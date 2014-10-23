//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/29/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewController.h"
#import "StringrNavigationController.h"
#import "UIColor+StringrColors.h"

@interface StringrDetailViewController () <QMBParallaxScrollViewControllerDelegate>

@end

@implementation StringrDetailViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor stringrLightGrayColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
