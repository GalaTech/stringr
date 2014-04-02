//
//  StringrPhotoTopDetailViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTopViewController.h"
#import "ParseImagePager.h"
#import "ParseImagePager.h"

@protocol StringrPhotoDetailTopViewControllerImagePagerDelegate;

@interface StringrPhotoDetailTopViewController : StringrDetailTopViewController

@property (strong, nonatomic) NSArray *photosToLoad;
@property (strong, nonatomic) id<StringrPhotoDetailTopViewControllerImagePagerDelegate> delegate;
@property (strong, nonatomic) UIImage *currentlyPresentPhoto;

/**
 * Will return an image in the current viewer at a given index.
 * @param index The index for the photo that you wish to have returned. The index must be in range of the number of photos.
 */
- (UIImage *)photoAtIndex:(NSUInteger)index;

@end


/**
 * Methods to retrieve callbacks upon the operation of the photo viewer. 
 */
@protocol StringrPhotoDetailTopViewControllerImagePagerDelegate <NSObject>

- (void)photoViewer:(ParseImagePager *)photoViewer didScrollToIndex:(NSUInteger)index;
- (void)photoViewer:(ParseImagePager *)photoViewer didTapPhotoAtIndex:(NSUInteger)index;

@end