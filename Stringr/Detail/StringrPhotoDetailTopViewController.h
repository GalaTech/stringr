//
//  StringrPhotoTopDetailViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTopViewController.h"
#import "KIImagePager.h"
#import "ParseImagePager.h"

@protocol StringrPhotoDetailTopViewControllerImagePagerDelegate;

@interface StringrPhotoDetailTopViewController : StringrDetailTopViewController

@property (strong, nonatomic) NSArray *photosToLoad;
@property (strong, nonatomic) id<StringrPhotoDetailTopViewControllerImagePagerDelegate> delegate;

@end


@protocol StringrPhotoDetailTopViewControllerImagePagerDelegate <NSObject>

- (void)photoViewer:(KIImagePager *)photoViewer didScrollToIndex:(NSUInteger)index;
- (void)photoViewer:(KIImagePager *)photoViewer didTapPhotoAtIndex:(NSUInteger)index;

@end