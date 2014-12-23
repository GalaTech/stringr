//
//  StingrExploreCategory.m
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrExploreCategory.h"

@implementation StringrExploreCategory

- (UIColor *)categoryColor
{
    return [UIColor colorWithRed:self.rgbColor.red / 255.0f green:self.rgbColor.green / 255.0f blue:self.rgbColor.blue / 255.0f alpha:1.0f];
}

@end
