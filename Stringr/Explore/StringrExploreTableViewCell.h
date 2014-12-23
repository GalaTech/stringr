//
//  StringrExploreTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrExploreCategory;

extern CGFloat const StringrExploreCellHeight;

@interface StringrExploreTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIView *categoryImageView;

- (void)configureForCategory:(StringrExploreCategory *)category;

@end
