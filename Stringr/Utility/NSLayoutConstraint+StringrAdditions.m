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

@end
