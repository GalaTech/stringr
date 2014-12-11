//
//  StringrContainerScrollViewDelegate.h
//  Stringr
//
//  Created by Jonathan Howard on 12/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StringrContainerScrollViewDelegate <NSObject>

@optional
- (void)containerViewDidScroll:(UIScrollView *)scrollView;
- (void)containerViewDidScrollToTop:(UIScrollView *)scrollView;
- (void)containerViewDidScrollDidEndDecelerating:(UIScrollView *)scrollView;
- (void)containerViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
