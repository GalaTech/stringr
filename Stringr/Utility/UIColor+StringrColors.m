//
//  UIColor+StringrColors.m
//  Stringr
//
//  Created by Jonathan Howard on 10/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "UIColor+StringrColors.h"

@implementation UIColor (StringrColors)

#pragma mark - Private

+ (UIColor *)colorwithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0];
}

#pragma mark - General

+ (UIColor *)stringrLightGrayColor
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}


+ (UIColor *)stringrTabBarItemColor
{
    return [UIColor colorWithWhite:0.78 alpha:1.0];
}

#pragma mark - TableView

+ (UIColor *)stringTableViewBackgroundColor
{
    return [self stringrLightGrayColor];
}


#pragma mark - CollectionView

+ (UIColor *)stringCollectionViewBackgroundColor
{
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}


#pragma mark - Logo

+ (UIColor *)stringrLogoRedColor
{
    return [self colorwithRed:254.0f green:17.0f blue:0.0f];
}


+ (UIColor *)stringrLogoOrangeColor
{
    return [self colorwithRed:255.0f green:107.0f blue:0.0f];
}


+ (UIColor *)stringrLogoYellowColor
{
    return [self colorwithRed:255.0f green:186.0f blue:0.0f];
}


+ (UIColor *)stringrLogoGreenColor
{
    return [self colorwithRed:67.0f green:167.0f blue:41.0f];
}


+ (UIColor *)stringrLogoTurquoiseColor
{
    return [self colorwithRed:1.0f green:151.0f blue:147.0f];
}


+ (UIColor *)stringrLogoBlueColor
{
    return [self colorwithRed:10.0f green:81.0f blue:161.0f];
}


+ (UIColor *)stringrLogoPurpleColor
{
    return [self colorwithRed:70.0f green:12.0f blue:128.0f];
}

+ (NSArray *)defaultStringrColors
{
    return @[[UIColor stringrLogoRedColor], [UIColor stringrLogoOrangeColor], [UIColor stringrLogoYellowColor], [UIColor stringrLogoGreenColor], [UIColor stringrLogoTurquoiseColor], [UIColor stringrLogoBlueColor], [UIColor stringrLogoPurpleColor]];
}


#pragma mark - Label

+ (UIColor *)stringrHandleColor
{
    return [self colorwithRed:208.0f green:76.0f blue:76.0f];
}


+ (UIColor *)stringrHashtagColor
{
    return [self colorwithRed:123.0f green:162.0f blue:214.0f];
}


+ (UIColor *)stringrPrimaryLabelColor
{
    return [self colorwithRed:67.0f green:67.0f blue:67.0f];
}

+ (UIColor *)stringrSecondaryLabelColor
{
    return [self colorwithRed:181.0f green:181.0f blue:181.0f];
}



#pragma mark - Liked

+ (UIColor *)stringrLikedGreenColor
{
    return [self colorwithRed:109.0f green:159.0f blue:96.0f];
}


#pragma mark - Twitter

+ (UIColor *)twitterBlueColor
{
    return [UIColor colorWithRed:64/255.0f green:153/255.0f blue:255/255.0f alpha:1.0];
}


#pragma mark - Facebook

+ (UIColor *)facebookBlueColor
{
    return [UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0];
}


#pragma mark - Utility

+ (UIColor *)randomColor
{
    CGFloat red = (arc4random() % 255);
    CGFloat green = (arc4random() % 255);
    CGFloat blue = (arc4random() % 255);
    
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}


- (UIColor*)blendWithColor:(UIColor*)color alpha:(CGFloat)alpha
{
    alpha = MIN( 1.0, MAX( 0.0, alpha ) );
    CGFloat beta = 1.0 - alpha;
    
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    CGFloat red     = r1 * beta + r2 * alpha;
    CGFloat green   = g1 * beta + g2 * alpha;
    CGFloat blue    = b1 * beta + b2 * alpha;
    CGFloat newAlpha   = a1 * beta + a2 * alpha;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:newAlpha];
}

@end
