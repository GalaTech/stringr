//
//  StringrLoadingContentView.h
//  Stringr
//
//  Created by Jonathan Howard on 2/11/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrLoadingContentView;


@protocol StringrLoadingContentViewDelegate <NSObject>

- (void)loadingContentViewDidTapRefresh:(StringrLoadingContentView *)loadingContentView;

@end


@interface StringrLoadingContentView : UIView

@property (weak, nonatomic) id<StringrLoadingContentViewDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;

- (void)enableNoContentViewWithMessage:(NSString *)message;

@end
