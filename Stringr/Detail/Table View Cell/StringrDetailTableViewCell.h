//
//  StringrDetailTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 5/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrDetailTableViewCellDelegate;

@interface StringrDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StringrDetailTableViewCellDelegate> delegate;

@end

@protocol StringrDetailTableViewCellDelegate <NSObject>

- (void)tableViewCell:(StringrDetailTableViewCell *)cell tappedUserHandleWithName:(NSString *)name;
- (void)tableViewCell:(StringrDetailTableViewCell *)cell tappedHashtagWithText:(NSString *)text;

@end
