//
//  AFImagePager.h
//  AFImagePager
//
//  Created by Marcus Kida on 07.04.13. Supoprt for AFNetworking added by Gaurav Verma
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class OldParseImagePager;

@protocol OldParseImagePagerDataSource;

@protocol OldParseImagePagerDelegate;

@interface OldParseImagePager : UIView

@property (weak) IBOutlet id<OldParseImagePagerDataSource> dataSource;
@property (weak) IBOutlet id<OldParseImagePagerDelegate> delegate;

@property UIViewContentMode contentMode;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic) BOOL indicatorDisabled;

- (void) reloadData;

@end


@protocol OldParseImagePagerDataSource <NSObject>

@required
- (NSArray *) arrayWithImageUrlStrings;
- (NSArray *)arrayWithPhotoPFObjects;
- (UIViewContentMode)contentModeForImage:(NSUInteger)image;

@optional
- (UIImage *)placeHolderImageForImagePager;

@end


@protocol OldParseImagePagerDelegate <NSObject>

@optional
- (void) imagePager:(OldParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index;
- (void) imagePager:(OldParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index;


@end