//
//  StringrColorGenerator.h
//  Stringr
//
//  Created by Jonathan Howard on 1/10/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrColorGenerator : NSObject

- (instancetype)initWithColors:(NSArray *)colors;
+ (instancetype)generatorWithDefaultStringrColors;

/// Provides the next sequential color in the generator's color array.
- (UIColor *)nextColor;

/** Provides a random color from the generator's color array while never repeating
 * until all colors have been used.
 */
- (UIColor *)nextRandomColor;

@end
