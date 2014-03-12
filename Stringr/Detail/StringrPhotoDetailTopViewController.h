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

@end


@protocol StringrPhotoDetailTopViewControllerImagePagerDelegate <NSObject>

- (void)photoViewer:(ParseImagePager *)photoViewer didScrollToIndex:(NSUInteger)index;
- (void)photoViewer:(ParseImagePager *)photoViewer didTapPhotoAtIndex:(NSUInteger)index;

@end