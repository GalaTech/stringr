//
//  StingrExploreCategory.h
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"
#import "UIColor+StringrColors.h"

@interface StringrExploreCategory : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic) struct StringrRGBValue rgbColor;

- (UIColor *)categoryColor;

@end
