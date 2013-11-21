//
//  ViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (IBAction)publishString:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)closeProfileModal:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeDiscoverPreLoggedIn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loggedOut:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
