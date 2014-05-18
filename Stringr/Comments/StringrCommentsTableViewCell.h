//
//  StringrCommentsTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 1/31/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrCommentsTableViewCellDelegate;

@interface StringrCommentsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StringrCommentsTableViewCellDelegate> delegate;

- (void)setObjectForCommentCell:(PFObject *)object;
- (void)setRowForCommentCell:(NSUInteger)row;

@end


@protocol StringrCommentsTableViewCellDelegate <NSObject>

- (void)tappedCommentorUserProfileImage:(PFUser *)user;

@end