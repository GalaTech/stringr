//
//  StringrPhotoTopDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTopViewController.h"


@interface StringrPhotoDetailTopViewController () <ParseImagePagerDataSource, ParseImagePagerDelegate, ParseImagePagerDataSource, ParseImagePagerDelegate>

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



#pragma mark - Custom Acessors

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] initWithCapacity:[self.photosToLoad count]];
    }
    
    return _photos;
}




#pragma mark - Public

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    if (index > self.photos.count) {
        return nil;
    }
    
    UIImage *photo;
    
    if (self.photos) {
        NSDictionary *photoDictionary = [[NSDictionary alloc] init];
        
        for (photoDictionary in self.photos) {
            
            NSUInteger photoIndex = [[photoDictionary objectForKey:@"index"] unsignedIntegerValue];
            
            if (photoIndex == index) {
                photo = [photoDictionary objectForKey:@"photo"];
                return photo;
            }
        }
    }
    
    return photo;
}




#pragma mark - ParseImagePager DataSource

- (NSArray *)arrayWithPhotoPFObjects
{
    return self.photosToLoad;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFit;
}



#pragma mark - ParseImagePager Delegate

- (void)imagePager:(ParseImagePager *)imagePager didLoadImage:(UIImage *)image atIndex:(NSUInteger)index
{
    NSDictionary *photo = [[NSDictionary alloc] initWithObjectsAndKeys:image, @"photo", @(index), @"index", nil];
    [self.photos addObject:photo];
}

- (void)imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    if (index <= [self.photosToLoad count]) {
        if ([self.delegate respondsToSelector:@selector(photoViewer:didScrollToIndex:)]) {
            [self.delegate photoViewer:imagePager didScrollToIndex:index];
        }
    }
}

- (void)imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
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
