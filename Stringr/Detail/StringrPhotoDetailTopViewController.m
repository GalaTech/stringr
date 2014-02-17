//
//  StringrPhotoTopDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTopViewController.h"

@interface StringrPhotoDetailTopViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

@end

@implementation StringrPhotoDetailTopViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //[self.photoImage setFrame:self.photoScrollView.bounds];
    [self.photoImage setContentMode:UIViewContentModeScaleAspectFit];

    /*
    [self.photoScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.photoImage.frame) + 100, CGRectGetHeight(self.photoImage.frame) + 100)];
    [self.photoScrollView setMaximumZoomScale:10.0];
    [self.photoScrollView setMinimumZoomScale:1.0];
    
    [self.photoScrollView setDelegate:self];
     */
}

@end
