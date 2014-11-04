//
//  TestTableViewHeader.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;
@class TestTableViewHeader;

@protocol StringTableViewHeaderDelegate <NSObject>

@optional
- (void)profileImageTappedForUser:(PFUser *)user;
- (void)testTableViewHeader:(TestTableViewHeader *)tableViewHeader tappedInfoButton:(UIButton *)infoButton;

@end

@interface TestTableViewHeader : UITableViewHeaderFooterView

@property (strong, nonatomic, readonly) PFObject *string;
@property (nonatomic) BOOL editingEnabled;
@property (weak, nonatomic) id<StringTableViewHeaderDelegate> delegate;

- (void)configureHeaderWithString:(PFObject *)string;

@end
