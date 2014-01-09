//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringEditViewController.h"
#import "StringrStringDiscoveryTabBarViewController.h"

@interface StringrStringEditViewController ()

@end

@implementation StringrStringEditViewController

- (void)viewDidLoad
{
    self.title = @"Publish String";
    
    // Disables the menu from being able to be pulled out via gesture
    self.frostedViewController.panGestureEnabled = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(saveAndPublishString)];
    

    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(returnToPreviousScreen)];
}


- (void)saveAndPublishString
{
    UINavigationController *navController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    //StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    
    [navController popToRootViewControllerAnimated:YES];
}

- (void)returnToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
