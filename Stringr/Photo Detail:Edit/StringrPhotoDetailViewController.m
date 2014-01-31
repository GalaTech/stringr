//
//  StringrPhotoDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailViewController.h"
#import "StringrPhotoDetailTopViewController.h"
#import "StringrPhotoDetailTableViewController.h"
#import "StringrStringDetailViewController.h"

@interface StringrPhotoDetailViewController () <UIScrollViewDelegate>

@end

@implementation StringrPhotoDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.detailsEditable) {
        self.title = @"Edit Photo";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePhoto)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhotoEdit)];
        
        StringrPhotoDetailTopViewController *topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTopVC"];
        StringrPhotoDetailTableViewController *tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailEditTableVC"];
        
        [self setupWithTopViewController:topPhotoVC andTopHeight:300 andBottomViewController:tablePhotoVC];
    } else {
        self.title = @"Photo Details";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushToStringDetailPage)];
        
        StringrPhotoDetailTopViewController *topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTopVC"];
        StringrPhotoDetailTableViewController *tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTableVC"];
        
        [self setupWithTopViewController:topPhotoVC andTopHeight:300 andBottomViewController:tablePhotoVC];
    }

    [self enableTapGestureTopView:YES];
    [self setMaxHeight:CGRectGetHeight(self.view.frame)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    StringrPhotoDetailTopViewController *topPhotoVC = (StringrPhotoDetailTopViewController *)self.topViewController;
    [topPhotoVC.photoImage setImage:self.currentImage];
}




#pragma mark - Actions
                                              
- (void)pushToStringDetailPage
{
    StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    [self.navigationController pushViewController:stringDetailVC animated:YES];
}

- (void)savePhoto
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelPhotoEdit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - ParallaxController Delegate

- (void) parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state
{
    [self.navigationController setNavigationBarHidden:self.state == QMBParallaxStateFullSize animated:YES];
}


@end
