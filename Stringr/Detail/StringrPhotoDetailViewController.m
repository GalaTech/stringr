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
#import "StringrPhotoDetailEditTableViewController.h"
#import "StringrStringDetailViewController.h"
#import "OldParseImagePager.h"

@interface StringrPhotoDetailViewController () <StringrPhotoDetailTopViewControllerImagePagerDelegate>

@property (strong, nonatomic) StringrPhotoDetailTopViewController *topPhotoVC;

@end

@implementation StringrPhotoDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTopVC"];
    [self.topPhotoVC setPhotosToLoad:self.photosToLoad];
    [self.topPhotoVC setDelegate:self];
    
    StringrPhotoDetailTableViewController *tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTableVC"];
    [tablePhotoVC setPhotoDetailsToLoad:self.photosToLoad[0]];
    [tablePhotoVC setStringOwner:self.stringOwner];
    
    
    if (self.editDetailsEnabled) {
        self.title = @"Edit Photo";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePhoto)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhotoEdit)];
        
        tablePhotoVC = (StringrPhotoDetailEditTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailEditTableVC"];
    } else {
        self.title = @"Photo Details";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushToStringDetailPage)];
    }
    
    [self setupWithTopViewController:self.topPhotoVC andTopHeight:250 andBottomViewController:tablePhotoVC];

    ((KIImagePager *)self.topPhotoVC.view).indicatorDisabled = YES;
    
    
    [self enableTapGestureTopView:YES];
    
    // accounts for main info view so that it 'sticks' to the bottom of the view when you go full screen
    [self setMaxHeight:CGRectGetHeight(self.view.frame) - 41.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.state == QMBParallaxStateFullSize animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Actions
                                              
- (void)pushToStringDetailPage
{
    //TODO: Update the ability to share a photo
    /*
    StringrPhotoDetailTopViewController *topPhotoVC = (StringrPhotoDetailTopViewController *)self.topViewController;
    
    NSArray *photoToShare = @[[topPhotoVC.photoImage image]];
    UIActivityViewController *sharePhoto = [[UIActivityViewController alloc] initWithActivityItems:photoToShare applicationActivities:nil];
    
    [self presentViewController:sharePhoto animated:YES completion:nil];
    */
     
     
    //StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    //[self.navigationController pushViewController:stringDetailVC animated:YES];
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




#pragma mark - StringrPhotoDetailTopViewControllerImagePager Delegate

- (void)photoViewer:(KIImagePager *)photoViewer didScrollToIndex:(NSUInteger)index
{
    
}

- (void)photoViewer:(KIImagePager *)photoViewer didTapPhotoAtIndex:(NSUInteger)index
{
    [self handleTap:nil];
}

@end
