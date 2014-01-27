//
//  StringrPhotoDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailViewController.h"
#import "StringrPhotoTopDetailViewController.h"
#import "StringrPhotoDetailTableViewController.h"

@interface StringrPhotoDetailViewController () <UIScrollViewDelegate>

@end

@implementation StringrPhotoDetailViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Photo";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushToStringDetailPage)];
    
     
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnToPreviousScreen)];
    
    StringrPhotoTopDetailViewController *topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"topPhotoVC"];
    StringrPhotoDetailTableViewController *tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tablePhotoVC"];
    self.delegate = self;
    
    [self setupWithTopViewController:topPhotoVC andTopHeight:300 andBottomViewController:tablePhotoVC];
    
    [self enableTapGestureTopView:YES];
    
}




#pragma mark - Private
                                              
- (void)pushToStringDetailPage
{
    
}

- (void)returnToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - UIScrollView Delegate

@end
