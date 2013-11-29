//
//  GBPathImageView.h
//  GBControls
//
//  Created by Matteo Gobbi on 15/08/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GBPathImageViewTypeCircle,
    GBPathImageViewTypeSquare
} GBPathImageViewType;


@interface GBPathImageView : UIImageView

/**
 * Determines the type of path you are creating. It can either
 * be a circular or rectangular path.
 */
@property (nonatomic) GBPathImageViewType pathType;

/// Sets the color of the border
@property (nonatomic, strong) UIColor *borderColor;

/// Sets the color of the path
@property (nonatomic, strong) UIColor *pathColor;

/// Sets the width of the path
@property float pathWidth;


- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image;

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
           pathType:(GBPathImageViewType)pathType
          pathColor:(UIColor *)pathColor
        borderColor:(UIColor *)borderColor
          pathWidth:(float)pathWidth;


- (void)draw;

@end
