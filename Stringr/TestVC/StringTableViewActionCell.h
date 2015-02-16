//
//  TestTableViewFooterActionCell.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *StringTableViewActionCellIdentifier = @"StringTableViewActionCell";
static CGFloat FooterActionCellHeight = 80.0f;

@protocol StringTableViewActionCellDelegate;

@interface StringTableViewActionCell : UITableViewCell

@property (strong, nonatomic, readonly) StringrString *string;
@property (weak, nonatomic) id<StringTableViewActionCellDelegate> delegate;

- (void)configureActionCellWithString:(StringrString *)string;

@end

@protocol StringTableViewActionCellDelegate <NSObject>

- (void)actionCell:(StringTableViewActionCell *)cell tappedLikeButton:(UIButton *)button liked:(BOOL)liked withBlock:(void (^)(BOOL success))block;
- (void)actionCell:(StringTableViewActionCell *)cell tappedCommentButton:(UIButton *)button;
- (void)actionCell:(StringTableViewActionCell *)cell tappedActionButton:(UIButton *)button;

@end
