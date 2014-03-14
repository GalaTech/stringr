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

@interface StringrPhotoDetailViewController () <StringrPhotoDetailTopViewControllerImagePagerDelegate>

@property (strong, nonatomic) StringrPhotoDetailTopViewController *topPhotoVC;
@property (strong, nonatomic) StringrPhotoDetailTableViewController *tablePhotoVC;
@property (nonatomic) BOOL navigationBarIsHidden;

@end

@implementation StringrPhotoDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTopVC"];
    [self.topPhotoVC setPhotosToLoad:self.photosToLoad];
    [self.topPhotoVC setDelegate:self];
    
    self.tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailTableVC"];
    
    if (self.editDetailsEnabled) {
        self.title = @"Edit Photo";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePhoto)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhotoEdit)];
        
        self.tablePhotoVC = (StringrPhotoDetailEditTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailEditTableVC"];
        [self.tablePhotoVC setEditDetailsEnabled:YES];
    } else {
        self.title = @"Photo Details";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePhoto)];
    }
    
    [self.tablePhotoVC setPhotoDetailsToLoad:self.photosToLoad[self.selectedPhotoIndex]];
    [self.tablePhotoVC setStringOwner:self.stringOwner];
    
    [self setupWithTopViewController:self.topPhotoVC andTopHeight:250 andBottomViewController:self.tablePhotoVC];
    

    ((ParseImagePager *)self.topPhotoVC.view).indicatorDisabled = YES;
    // sets the photo viewer to be viewing the photo selected by the user
    [((ParseImagePager *) self.topPhotoVC.view) setCurrentPage:self.selectedPhotoIndex];
    
    
    [self enableTapGestureTopView:YES];
    
    // accounts for main info view so that it 'sticks' to the bottom of the view when you go full screen
    [self setMaxHeight:CGRectGetHeight(self.view.frame) - kStringrPFObjectDetailTableViewCellHeight];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // ensures that the navigation bar is properly displayed. Without this the bar will have
    // improper function after leaving and returning.
    [self.navigationController setNavigationBarHidden:self.navigationBarIsHidden animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // accounts for when a user taps on the comments button when in full screen
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Actions
                                              
- (void)sharePhoto
{
    //TODO: Update the ability to share a photo
    //StringrPhotoDetailTopViewController *topPhotoVC = (StringrPhotoDetailTopViewController *)self.topViewController;
    
    NSArray *photoToShare = @[[self.topPhotoVC photoAtIndex:self.selectedPhotoIndex]];
    
    if (photoToShare) {
        UIActivityViewController *sharePhoto = [[UIActivityViewController alloc] initWithActivityItems:photoToShare applicationActivities:nil];
    
        [self presentViewController:sharePhoto animated:YES completion:nil];
    }
    
     
     
    //StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
    //[self.navigationController pushViewController:stringDetailVC animated:YES];
}

// only used on edit photo views
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
    // If we are in the normal parallax state we make sure that the nav bar isn't hidden
    if (state == QMBParallaxStateVisible) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}




#pragma mark - StringrPhotoDetailTopViewControllerImagePager Delegate

- (void)photoViewer:(ParseImagePager *)photoViewer didScrollToIndex:(NSUInteger)index
{
    ScrollDirection direction;
    
    if (index < self.selectedPhotoIndex) {
        direction = ScrolledRight;
    } else {
        direction = ScrolledLeft;
    }
    
    
    [self.tablePhotoVC setPhotoDetailsToLoad:self.photosToLoad[index]];
    [self.tablePhotoVC reloadPhotoDetailsWithScrollDirection:direction];
    
    self.selectedPhotoIndex = index;
}

- (void)photoViewer:(ParseImagePager *)photoViewer didTapPhotoAtIndex:(NSUInteger)index
{
    // hides/shows the nav bar when the photo is tapped.
    [self.navigationController setNavigationBarHidden:!self.navigationBarIsHidden animated:YES];
    self.navigationBarIsHidden = !self.navigationBarIsHidden;
    [self handleTap:nil];
}

@end
