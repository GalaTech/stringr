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

@protocol ParseImagePagerDataSource;

@protocol ParseImagePagerDelegate;

@interface ParseImagePager : UIView

// Delegate and Datasource
@property (weak) IBOutlet id <ParseImagePagerDataSource> dataSource;
@property (weak) IBOutlet id <ParseImagePagerDelegate> delegate;

// General
@property (assign) UIViewContentMode contentMode;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic) CGPoint pageControlCenter;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL indicatorDisabled;
@property (nonatomic, assign) BOOL imageCounterDisabled;
@property (nonatomic, assign) BOOL hidePageControlForSinglePages; // Defaults YES

// Slideshow
@property (assign) NSUInteger slideshowTimeInterval; // Defaults 0.0f (off)
@property (assign) BOOL slideshowShouldCallScrollToDelegate; // Defaults YES

// Caption Label
@property (nonatomic, strong) UIColor *captionTextColor; // Defaults Black
@property (nonatomic, strong) UIColor *captionBackgroundColor; // Defaults White (with an alpha of .7f)
@property (nonatomic, strong) UIFont *captionFont; // Defaults to Helvetica 12.0f points

- (void) reloadData;
- (void) setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;

@end


@protocol ParseImagePagerDataSource <NSObject>

@required

- (NSArray *)arrayWithImages;
- (NSArray *)arrayWithPhotoPFObjects;
- (UIViewContentMode) contentModeForImage:(NSUInteger)image;

@optional
- (UIImage *) placeHolderImageForImagePager;
- (NSString *) captionForImageAtIndex:(NSUInteger)index;

@end

@protocol ParseImagePagerDelegate <NSObject>

@optional
- (void) imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index;
- (void) imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index;

@end