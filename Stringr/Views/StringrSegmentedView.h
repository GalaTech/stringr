//
//  StringrSegmentedView.h
//  Stringr
//
//  Created by Jonathan Howard on 11/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrSegmentedViewDelegate;

@interface StringrSegmentedView : UIView

@property (strong, nonatomic) NSArray *segments;
@property (weak, nonatomic) id<StringrSegmentedViewDelegate> delegate;

/**
 * Creates a new segmented control with the specified frame and segments.
 * There will be as many segments as there are items provided in the array.
 * @param frame The frame for the segmented control.
 * @param segments An array of StringrSegment objects.
 */
- (instancetype)initWithFrame:(CGRect)frame segments:(NSArray *)segments;

@end

@protocol StringrSegmentedViewDelegate <NSObject>

- (void)segmentedView:(StringrSegmentedView *)segmentedView didSelectItemAtIndex:(NSUInteger)index;

@end


@interface StringrSegment : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

@end


@interface StringrSegmentContainer : UIView

@end
