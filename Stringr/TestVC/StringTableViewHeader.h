//
//  TestTableViewHeader.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;
@class StringTableViewHeader;

@protocol StringTableViewHeaderDelegate <NSObject>

@optional
- (void)profileImageTappedForUser:(PFUser *)user;
- (void)stringTableViewHeader:(StringTableViewHeader *)tableViewHeader tappedInfoButton:(UIButton *)infoButton;

@end

@interface StringTableViewHeader : UITableViewHeaderFooterView

@property (strong, nonatomic, readonly) PFObject *string;
@property (nonatomic) BOOL editingEnabled;
@property (weak, nonatomic) id<StringTableViewHeaderDelegate> delegate;

- (void)configureHeaderWithString:(PFObject *)string;

@end
