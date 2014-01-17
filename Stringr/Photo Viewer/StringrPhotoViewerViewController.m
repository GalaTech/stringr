//
//  StringrPhotoViewerViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoViewerViewController.h"
#import "StringrDetailViewController.h"

@interface StringrPhotoViewerViewController ()

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
}




#pragma mark - Actions

- (void)pushDetailView
{
    //UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
