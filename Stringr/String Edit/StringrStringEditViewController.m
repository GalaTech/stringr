//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringEditViewController.h"

@interface StringrStringEditViewController ()

@end

@implementation StringrStringEditViewController

- (void)viewDidLoad
{
    self.title = @"Publish String";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publish"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(saveAndPublishString)];
}


- (void)saveAndPublishString
{
    UINavigationController *navController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    [navController popToRootViewControllerAnimated:YES];
}

@end
