//
//  TestTableViewFooterCellTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat FooterTitleCellHeight = 30.0f;

@interface TestTableViewFooterTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *TestTitle;

- (void)configureFooterCellWithString:(PFObject *)string;

@end
