//
//  StringrActivityTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 4/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrActivityTableViewCellDelegate;

@interface StringrActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StringrActivityTableViewCellDelegate> delegate;

- (void)setObjectForActivityCell:(PFObject *)object;
- (void)setRowForActivityCell:(NSUInteger)row;

@end


@protocol StringrActivityTableViewCellDelegate <NSObject>

- (void)tappedActivityUserProfileImage:(PFUser *)user;

@end
