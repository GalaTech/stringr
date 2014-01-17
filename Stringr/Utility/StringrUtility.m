//
//  StringrUtility.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUtility.h"

@implementation StringrUtility


+ (void)showMenu:(REFrostedViewController *)menuViewController
{
    [menuViewController presentMenuViewController];
}


+ (UIColor *)kStringrVeryLightGrayColor
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

@end
