//
//  StringrStringDiscoveryTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrDiscoveryTabBarViewController.h"
#import "StringrLoginViewController.h"
#import "StringrNavigationController.h"
#import "StringrUtility.h"

@interface StringrDiscoveryTabBarViewController ()

@end

@implementation StringrDiscoveryTabBarViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // sets the title of the controller to the initial selected tab bar item
    self.title = @"Following";
    
    [self.tabBar setTintColor:[StringrConstants kStringrBlueColor]];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
    StringrNavigationController *navVC = self.viewControllers[0];
    UIViewController *visibleVC = navVC.topViewController;
    
    StringrLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [visibleVC presentViewController:loginVC animated:YES completion:nil];
     */
}





@end
