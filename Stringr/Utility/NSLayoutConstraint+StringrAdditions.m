//
//  NSLayoutConstraint+StringrAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 1/7/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "NSLayoutConstraint+StringrAdditions.h"

@implementation NSLayoutConstraint (StringrAdditions)

+ (NSArray *)constraintsToFillSuperviewWithView:(UIView *)view
{
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:kNilOptions metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:kNilOptions metrics:nil views:views]];
    return [constraints copy];
}


+ (NSArray *)constraintsToSizeView:(UIView *)view size:(CGSize)size
{
    return @[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.height], [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.width]];
}


+ (NSArray *)constraintsToCenterView:(UIView *)view inView:(UIView *)superView
{
    return @[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

@end
