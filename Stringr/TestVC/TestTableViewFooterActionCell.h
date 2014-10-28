//
//  TestTableViewFooterActionCell.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat FooterActionCellHeight = 55.0f;

@protocol TestTableViewFooterActionDelegate;

@interface TestTableViewFooterActionCell : UITableViewCell

@property (strong, nonatomic, readonly) PFObject *string;
@property (weak, nonatomic) id<TestTableViewFooterActionDelegate> delegate;

- (void)configureActionCellWithString:(PFObject *)string;

@end

@protocol TestTableViewFooterActionDelegate <NSObject>

- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedLikeButton:(UIButton *)button liked:(BOOL)liked withBlock:(void (^)(BOOL success))block;
- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedCommentButton:(UIButton *)button;
- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedActionButton:(UIButton *)button;

@end
