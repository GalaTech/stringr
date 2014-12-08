//
//  UIImage+StringrImageAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 11/28/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "UIImage+StringrImageAdditions.h"

@implementation UIImage (StringrImageAdditions)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    
    CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
