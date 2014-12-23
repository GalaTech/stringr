//
//  UIImage+StringrImageAdditions.h
//  Stringr
//
//  Created by Jonathan Howard on 11/28/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (StringrImageAdditions)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
