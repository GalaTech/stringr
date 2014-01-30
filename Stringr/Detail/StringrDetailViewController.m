//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/29/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailViewController.h"

@interface StringrDetailViewController () <QMBParallaxScrollViewControllerDelegate>

@end

@implementation StringrDetailViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self enableTapGestureTopView:YES];
    [self setMaxHeight:CGRectGetHeight(self.view.frame)];
}



@end
