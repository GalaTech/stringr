//
//  UIFont+StringrFonts.m
//  Stringr
//
//  Created by Jonathan Howard on 10/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "UIFont+StringrFonts.h"

@implementation UIFont (StringrFonts)

#pragma mark - Primary

+ (UIFont *)stringrPrimaryLabelFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Avenir" size:size];
}


+ (UIFont *)stringrPrimaryLabelMediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

#pragma mark - Primary Label Fonts
+ (UIFont *)stringrPrimaryLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
}


+ (UIFont *)stringrPrimaryLabelMediumFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
}


+ (UIFont *)stringrPrimaryLabelBoldFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:13];
}


+ (UIFont *)stringrPrimaryStringTitleLabelFont
{
    return [UIFont fontWithName:@"Avenir Light" size:15];
}


+ (UIFont *)stringrHeaderPrimaryLabelFont
{
    return [UIFont fontWithName:@"Avenir" size:16.5];
}


+ (UIFont *)stringrHeaderSecondaryLabelFont
{
    return [UIFont fontWithName:@"Avenir" size:12.5];
}


#pragma mark - Secondary Label Fonts

+ (UIFont *)stringrSecondaryLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
}


+ (UIFont *)stringrSecondaryLabelMediumFont
{
    return [UIFont fontWithName:@"HelveticaNeue-medium" size:9];
}


+ (UIFont *)stringrSecondaryLabelBoldFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:9];
}


#pragma mark - Profile

+ (UIFont *)stringrProfileNameFont
{
    return [UIFont fontWithName:@"Avenir Next" size:20.0f];
}


+ (UIFont *)stringrProfileDescriptionFont
{
    return [UIFont fontWithName:@"Avenir Next" size:14.0f];
}

@end
