//
//  UIColor+StringrColors.h
//  Stringr
//
//  Created by Jonathan Howard on 10/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

struct StringrRGBValue {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
};

@interface UIColor (StringrColors)

// General
+ (UIColor *)stringrLightGrayColor;
+ (UIColor *)stringrTabBarItemColor;

// Logo
+ (UIColor *)stringrLogoRedColor;
+ (UIColor *)stringrLogoOrangeColor;
+ (UIColor *)stringrLogoYellowColor;
+ (UIColor *)stringrLogoGreenColor;
+ (UIColor *)stringrLogoTurquoiseColor;
+ (UIColor *)stringrLogoBlueColor;
+ (UIColor *)stringrLogoPurpleColor;

+ (NSArray *)defaultStringrColors;


// Label
+ (UIColor *)stringrHashtagColor;
+ (UIColor *)stringrHandleColor;

+ (UIColor *)stringrPrimaryLabelColor;
+ (UIColor *)stringrSecondaryLabelColor;


// TableView
+ (UIColor *)stringTableViewBackgroundColor;


// CollectionView
+ (UIColor *)stringCollectionViewBackgroundColor;


+ (UIColor *)stringrLikedGreenColor;


// 3rd Party Social Networks
+ (UIColor *)facebookBlueColor;
+ (UIColor *)twitterBlueColor;

// Utility
+ (UIColor *)randomColor;
- (UIColor*)blendWithColor:(UIColor*)color alpha:(CGFloat)alpha;

@end
