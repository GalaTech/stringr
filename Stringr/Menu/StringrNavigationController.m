//
//  StringrNavigationController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrNavigationController.h"

@interface StringrNavigationController ()

@end

@implementation StringrNavigationController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    self.navigationBar.tintColor = [UIColor grayColor];
}




#pragma mark - Action Handlers

/*
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}
*/

@end
