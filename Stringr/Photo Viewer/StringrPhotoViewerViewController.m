//
//  StringrPhotoViewerViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoViewerViewController.h"
#import "StringrTempDetailViewController.h"

@interface StringrPhotoViewerViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoViewImageView;

@end

@implementation StringrPhotoViewerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // This is what should be in the top right, but you can't assign a UIButton to a bar button item
    // It's no problem because I will most likely use custom graphics for the button
    // UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.title = @"Photo Viewer";
    
    // Disables the menu from being able to be pulled out via gesture
    //self.frostedViewController.panGestureEnabled = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(pushDetailView)];
    
    [self.photoViewImageView setImage:self.photoViewerImage];
    [self.photoViewImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavBar)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
}




#pragma mark - Actions

- (void)pushDetailView
{
    //UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrTempDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)showNavBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

@end
