//
//  StringrColoredView.h
//  Stringr
//
//  Created by Jonathan Howard on 11/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrColoredView : UIView

+ (instancetype)defaultColoredView;
+ (instancetype)coloredViewWithColors:(NSArray *)colors;
- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors;

@end
