//
//  StringrNoContentView.h
//  Stringr
//
//  Created by Jonathan Howard on 5/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrNoContentViewDelegate;

@interface StringrNoContentView : UIView

@property (weak, nonatomic) id<StringrNoContentViewDelegate> delegate;

- (instancetype)initWithNoContentText:(NSString *)text; // Designated Initializer

- (instancetype)initWithFrame:(CGRect)frame andNoContentText:(NSString *)text;

- (void)setTitleForExploreOptionButton:(NSString *)title;

@end


@protocol StringrNoContentViewDelegate <NSObject>

@optional

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton;

@end
