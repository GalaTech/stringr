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
- (void)stringHeader:(StringTableViewHeader *)header didTapPhotoViewForString:(StringrString *)string;

@end

@interface StringTableViewHeader : UITableViewHeaderFooterView

@property (strong, nonatomic, readonly) StringrString *string;
@property (nonatomic) BOOL editingEnabled;
@property (weak, nonatomic) id<StringTableViewHeaderDelegate> delegate;

- (void)configureHeaderWithString:(StringrString *)string;

@end
