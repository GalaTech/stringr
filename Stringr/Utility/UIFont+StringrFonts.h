//
//  UIFont+StringrFonts.h
//  Stringr
//
//  Created by Jonathan Howard on 10/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (StringrFonts)

+ (UIFont *)stringrPrimaryLabelFontWithSize:(CGFloat)size;
+ (UIFont *)stringrPrimaryLabelMediumFontWithSize:(CGFloat)size;

+ (UIFont *)stringrPrimaryLabelFont;
+ (UIFont *)stringrPrimaryLabelMediumFont;
+ (UIFont *)stringrPrimaryLabelBoldFont;

+ (UIFont *)stringrSecondaryLabelFont;
+ (UIFont *)stringrSecondaryLabelMediumFont;
+ (UIFont *)stringrSecondaryLabelBoldFont;

+ (UIFont *)stringrHeaderPrimaryLabelFont;
+ (UIFont *)stringrHeaderSecondaryLabelFont;

+ (UIFont *)stringrPrimaryStringTitleLabelFont;

+ (UIFont *)stringrProfileNameFont;

@end
