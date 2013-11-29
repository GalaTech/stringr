//
//  StringrLoginViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrLoginViewController.h"
#import "StringrStringDiscoveryTabBarViewController.h"

#import "StringrProfileViewController.h"

@interface StringrLoginViewController ()

@end

@implementation StringrLoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.frostedViewController.panGestureEnabled = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disables the menu from being able to be pulled out via gesture
    self.frostedViewController.panGestureEnabled = NO;
}




- (IBAction)pushToNewView:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    [navigationController pushViewController:stringDiscoveryVC animated:YES];
    
}


- (IBAction)pushToPreLoggedInDiscover:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    [navigationController pushViewController:stringDiscoveryVC animated:YES];
}


@end
