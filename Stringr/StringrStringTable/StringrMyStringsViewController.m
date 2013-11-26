//
//  StringrMyStringsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMyStringsViewController.h"
#import "StringrStringEditViewController.h"


@interface StringrMyStringsViewController ()

@end

@implementation StringrMyStringsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Strings";
    
    //TODO: The action for this button is to edit a selected string. The selected string should be pushed in
    // with this method so that it can easil be transferred to the edit controller.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(pushToStringEdit)];
}


- (void)pushToStringEdit
{
    StringrStringEditViewController *stringEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
    
    [(UINavigationController *)self.frostedViewController.contentViewController pushViewController:stringEditVC animated:YES];
}


@end
