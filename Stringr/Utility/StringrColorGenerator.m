//
//  StringrColorGenerator.m
//  Stringr
//
//  Created by Jonathan Howard on 1/10/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrColorGenerator.h"
#import "UIColor+StringrColors.h"

@interface StringrColorGenerator ()

@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSMutableArray *usedColors;

@end

@implementation StringrColorGenerator

#pragma mark - Lifecycle

- (instancetype)initWithColors:(NSArray *)colors
{
    self = [super init];
    
    if (self) {
        _colors = [colors mutableCopy];
    }
    
    return self;
}


+ (instancetype)generatorWithDefaultStringrColors
{
    return [[StringrColorGenerator alloc] initWithColors:[UIColor defaultStringrColors]];
}


#pragma mark - Accessors

- (NSMutableArray *)usedColors
{
    if (!_usedColors) {
        _usedColors = [[NSMutableArray alloc] initWithCapacity:self.colors.count];
    }
    
    return _usedColors;
}


#pragma mark - Public

- (UIColor *)nextColor
{
    return [self nextColor:NO];
}


- (UIColor *)nextRandomColor
{
    return [self nextColor:YES];
}


#pragma mark - Private

- (UIColor *)nextColor:(BOOL)random
{
    if (self.colors.count == 0) {
        self.colors = [self.usedColors mutableCopy];
        [self.usedColors removeAllObjects];
    }
    
    UIColor *color = (random) ? self.colors[arc4random() % self.colors.count] : [self.colors firstObject];
    [self.colors removeObject:color];
    
    [self.usedColors addObject:color];
    
    return color;
}

@end
