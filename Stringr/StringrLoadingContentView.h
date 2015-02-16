//
//  StringrLoadingContentView.h
//  Stringr
//
//  Created by Jonathan Howard on 2/11/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrLoadingContentView : UIView

- (void)startLoading;
- (void)stopLoading;

- (void)enableNoContentViewWithMessage:(NSString *)message;

@end
