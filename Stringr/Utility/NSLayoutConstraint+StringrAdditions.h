//
//  NSLayoutConstraint+StringrAdditions.h
//  Stringr
//
//  Created by Jonathan Howard on 1/7/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (StringrAdditions)

+ (NSArray *)constraintsToFillSuperviewWithView:(UIView *)view;

@end
