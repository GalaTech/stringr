//
//  StringrFooterView.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrPathImageView.h"

@interface StringrFooterView : UIView

@property (nonatomic) BOOL isFullWidthCell;

@property (strong, nonatomic) StringrPathImageView *profileImageView;
@property (strong, nonatomic) UILabel *profileNameLabel;
@property (strong, nonatomic) UILabel *uploadDateLabel;
@property (strong, nonatomic) UILabel *commentsTextLabel;
@property (strong, nonatomic) UILabel *likesTextLabel;



- (UIView *)initWithFrame:(CGRect)frame withFullWidthCell:(BOOL)isFullWidthCell;

@end
