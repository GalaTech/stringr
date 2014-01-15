//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringEditViewController.h"
#import "StringrStringDiscoveryTabBarViewController.h"

@interface StringrStringEditViewController () <UIAlertViewDelegate>

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
    UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view setBackgroundColor:veryLightGrayColor];
}


- (void)saveAndPublishString
{
    //UINavigationController *navController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    //StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // Modal
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)returnToPreviousScreen
{
    UIAlertView *cancelStringAlert = [[UIAlertView alloc] initWithTitle:@"Cancel String" message:@"Are you sure that you want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", @"Save for later", nil];
    
    [cancelStringAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    } else if (buttonIndex == 2) {
        //UIAlertView *stringSavedAlert = [[UIAlertView alloc] initWithTitle:@"String Saved!" message:@"Your string has been saved for future editing." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        //[stringSavedAlert show];
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
