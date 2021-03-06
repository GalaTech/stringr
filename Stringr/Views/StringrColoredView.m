//
//  StringrColoredView.m
//  Stringr
//
//  Created by Jonathan Howard on 11/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrColoredView.h"
#import "UIColor+StringrColors.h"

@implementation StringrColoredView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupColoredHeaderRibbon:colors];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupColoredHeaderRibbon:[UIColor defaultStringrColors]];
    }
    
    return self;
}


+ (instancetype)defaultColoredView
{
    CGRect coloredRect = CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0f);
    StringrColoredView *coloredView = [[StringrColoredView alloc] initWithFrame:coloredRect colors:[UIColor defaultStringrColors]];
    
    return coloredView;
}


+ (instancetype)coloredViewWithColors:(NSArray *)colors
{
    CGRect coloredRect = CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0f);
    StringrColoredView *coloredView = [[StringrColoredView alloc] initWithFrame:coloredRect colors:colors];
    
    return coloredView;
}


#pragma mark - Public


#pragma mark - Private

- (void)setupColoredHeaderRibbon:(NSArray *)colors
{
    CGSize colorBlockSize = CGSizeMake(CGRectGetWidth(self.frame) / colors.count, CGRectGetHeight(self.frame));
    
    for (int i = 0; i < colors.count; i++) {
        UIImageView *colorBlock = [[UIImageView alloc] initWithFrame:CGRectMake(i * colorBlockSize.width, 0, colorBlockSize.width, colorBlockSize.height)];
        
        [colorBlock setBackgroundColor:colors[i]];
        [self addSubview:colorBlock];
    }
}


@end
