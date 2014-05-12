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
#import "StringrNavigationController.h"

@interface StringrPhotoDetailViewController () <StringrPhotoDetailTopViewControllerImagePagerDelegate, StringrPhotoDetailEditTableViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) StringrPhotoDetailTopViewController *topPhotoVC;
@property (weak, nonatomic) StringrPhotoDetailTableViewController *tablePhotoVC;
@property (nonatomic) BOOL navigationBarIsHidden;

@end

@implementation StringrPhotoDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailTopViewID];
    [self.topPhotoVC setPhotosToLoad:self.photosToLoad];
    [self.topPhotoVC setDelegate:self];
    
    self.tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailTableViewID];
    
    if (self.editDetailsEnabled) {
        self.title = @"Edit Photo";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePhoto)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhotoEdit)];
        
        self.tablePhotoVC = (StringrPhotoDetailEditTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEditPhotoDetailTableViewID];
        [self.tablePhotoVC setEditDetailsEnabled:YES];
        
        // this is necessary so that delegation from the table view to the string view is accessible
        // this delegation is set in the string top vc that presents the edit photo vc
        StringrPhotoDetailEditTableViewController *editPhotoTableVC = (StringrPhotoDetailEditTableViewController *)self.tablePhotoVC;
        [editPhotoTableVC setDelegate:self.delegateForPhotoController];
    } else {
        self.title = @"Photo Details";
        
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePhoto)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"options_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(photoActionSheet)];
    }
    
    [self.tablePhotoVC setPhotoDetailsToLoad:self.photosToLoad[self.selectedPhotoIndex]];
    
    [self setupWithTopViewController:self.topPhotoVC andTopHeight:250 andBottomViewController:self.tablePhotoVC];
    

    ((ParseImagePager *)self.topPhotoVC.view).indicatorDisabled = YES;
    // sets the photo viewer to be viewing the photo selected by the user
    [((ParseImagePager *) self.topPhotoVC.view) setCurrentPage:self.selectedPhotoIndex];
    
    
    [self enableTapGestureTopView:YES];
    
    // accounts for main info view so that it 'sticks' to the bottom of the view when you go full screen
    [self setMaxHeight:CGRectGetHeight(self.view.frame) - kStringrPFObjectDetailTableViewCellHeight];
    [self setMaxHeightBorder:FLT_MAX];
    
    // fetches the string owner if needed. This will most likely only be necessary for instances where a user is
    // accessing the string owner via a photo through activity feed.
    [self.stringOwner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.stringOwner = object;
        }
    }];
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

- (void)dealloc
{
    NSLog(@"dealloc photo detail");
}




#pragma mark - Actions

- (void)photoActionSheet
{
    UIActionSheet *photoOptionsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Options" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Share Photo", @"String Owner", nil];
    
    PFObject *photo = [self.photosToLoad objectAtIndex:self.selectedPhotoIndex];
    
    int cancelIndex = 2;
    
    if ([photo.ACL getWriteAccessForUser:[PFUser currentUser]]) {
        [photoOptionsActionSheet addButtonWithTitle:@"Edit Photo"];
        cancelIndex++;
    }
    
    [photoOptionsActionSheet addButtonWithTitle:@"Cancel"];
    [photoOptionsActionSheet setCancelButtonIndex:cancelIndex];
    
    [photoOptionsActionSheet showInView:self.view];
}

- (void)sharePhoto
{
    NSArray *photoToShare = @[[self.topPhotoVC photoAtIndex:self.selectedPhotoIndex]];
    
    if (photoToShare) {
        UIActivityViewController *sharePhoto = [[UIActivityViewController alloc] initWithActivityItems:photoToShare applicationActivities:nil];
    
        [self presentViewController:sharePhoto animated:YES completion:nil];
    }
}

- (void)pushToStringOwner
{
    // don't want to overwrite the stringOwner property because then once it's been written once
    // we would no longer be able to check if it's nil.
    PFObject *stringOwner = self.stringOwner;
    
    if (!stringOwner) {
        // the string owner for the specific photo that is currently being viewed
        stringOwner = [[self.photosToLoad objectAtIndex:self.selectedPhotoIndex] objectForKey:kStringrPhotoStringKey];
    }
    
    StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
    [stringDetailVC setStringToLoad:stringOwner];
    [self.navigationController pushViewController:stringDetailVC animated:YES];
}

- (void)pushToEditPhoto
{
    StringrPhotoDetailViewController *editPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
    PFObject *photo = [self.photosToLoad objectAtIndex:self.selectedPhotoIndex];
    [editPhotoVC setPhotosToLoad:@[photo]];
    [editPhotoVC setSelectedPhotoIndex:0];
    [editPhotoVC setEditDetailsEnabled:YES];
    [editPhotoVC setStringOwner:nil];
    [editPhotoVC setDelegateForPhotoController:self];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:editPhotoVC];
    
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

// only used on edit photo views
- (void)savePhoto
{
    [self dismissViewControllerAnimated:YES completion:^{
        PFObject *photo = [self.photosToLoad objectAtIndex:self.selectedPhotoIndex];
        [photo saveInBackground];
    }];
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
    
    PFObject *photo = self.photosToLoad[index];
    
    [self.tablePhotoVC setPhotoDetailsToLoad:photo];
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



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share Photo"]) {
        [self sharePhoto];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"String Owner"]) {
        [self pushToStringOwner];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Edit Photo"]) {
        [self pushToEditPhoto];
    }
}



#pragma mark - StringrPhotoDetailEditTableViewControllerDelegate

- (void)deletePhotoFromString:(PFObject *)photo
{
    [self dismissViewControllerAnimated:YES completion:nil];

    [photo deleteEventually];
 
}


@end
