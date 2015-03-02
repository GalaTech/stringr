//
//  StringrContainerScrollViewDelegate.h
//  Stringr
//
//  Created by Jonathan Howard on 12/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StringrContainerScrollViewDelegate <NSObject>

- (UIScrollView *)containerScrollView;
- (void)adjustScrollViewTopInset:(CGFloat)inset;

@optional
- (void)containerViewDidScroll:(UIScrollView *)scrollView;

@end
