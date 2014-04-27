//
//  StringrPathImageView.h
//  Stringr
//
//  Created by Jonathan Howard on 1/9/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrPathImageView : PFImageView



/// Set the color for a StringrPathImageView image
@property (strong, nonatomic) UIColor *pathColor;
/// Set the image for a StringrPathImageView
@property (strong, nonatomic) UIImage *pathImage;
/// Set the width of the border for a StringrPathImageView
@property (nonatomic) float pathWidth;


/**
 * Creates a rounded UIImage view with a colored border.
 *
 * @param frame The frame that you want to use for this UIImageView
 * @param image The image that you are wanting to be used for this Image View
 * @param color The color that you want the border of the path to be
 * @param width The thickness of the border around the image
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)image pathColor:(UIColor *)color pathWidth:(float)width;

/**
 * Sets the image to be inside of a circular path
 */
- (void)setImageToCirclePath;

- (void)loadInBackgroundWithIndicator;


@end
