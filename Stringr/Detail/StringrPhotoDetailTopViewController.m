//
//  StringrPhotoTopDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTopViewController.h"


@interface StringrPhotoDetailTopViewController () <ParseImagePagerDataSource, ParseImagePagerDelegate, KIImagePagerDataSource, KIImagePagerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

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
    
    
    
}




#pragma mark - ParseImagePager DataSource

- (NSArray *)arrayWithImages
{
    return nil;
    //return self.photos;
}

- (NSArray *)arrayWithPhotoPFObjects
{
    //return nil;
    return self.photosToLoad;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFit;
}



#pragma mark - ParseImagePager Delegate


- (void)imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    if (index <= [self.photosToLoad count]) {
        if ([self.delegate respondsToSelector:@selector(photoViewer:didScrollToIndex:)]) {
            [self.delegate photoViewer:imagePager didScrollToIndex:index];
        }
    }
}

- (void)imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoViewer:didTapPhotoAtIndex:)]) {
        [self.delegate photoViewer:imagePager didTapPhotoAtIndex:index];
    }
}

/*
- (void)imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"did scroll %d", index);
}

- (void)imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"did tap %d", index);
}
*/


@end
