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
