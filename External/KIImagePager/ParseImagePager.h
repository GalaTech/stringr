//
//  KIImagePager.h
//  KIImagePager
//
//  Created by Marcus Kida on 07.04.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ParseImagePager;

@protocol ParseImagePagerDataSource

@required
- (NSArray *)arrayWithPhotoPFObjects;
//- (NSArray *)arrayWithImages;
- (UIViewContentMode) contentModeForImage:(NSUInteger)image;

@optional
- (UIImage *) placeHolderImageForImagePager;

@end

@protocol ParseImagePagerDelegate <NSObject>

@optional
- (void) imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index;
- (void) imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index;
- (void)imagePager:(ParseImagePager *)imagePager didLoadImage:(UIImage *)image atIndex:(NSUInteger)index;

@end

@interface ParseImagePager : UIView

@property (weak) IBOutlet id <ParseImagePagerDataSource> dataSource;
@property (weak) IBOutlet id <ParseImagePagerDelegate> delegate;

@property (assign) UIViewContentMode contentMode;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL indicatorDisabled;
@property (assign) NSUInteger slideshowTimeInterval;


- (void) reloadData;
- (void) setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;

@end

