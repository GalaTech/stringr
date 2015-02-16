//
//  TestTableViewFooterCellTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrLabel.h"

static NSString *StringTableViewTitleCellIdentifier = @"StringTableViewTitleCell";
static CGFloat FooterTitleCellHeight = 28.0f;

@interface StringTableViewTitleCell : UITableViewCell

@property (strong, nonatomic, readonly) StringrString *string;
@property (weak, nonatomic) IBOutlet StringrLabel *stringTitle;

- (void)configureFooterCellWithString:(StringrString *)string;

@end
