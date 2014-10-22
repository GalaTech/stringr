//
//  TestTableViewFooterCellTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterTitleCell.h"

@interface TestTableViewFooterTitleCell ()

@property (nonatomic) CGRect cellBounds;

@end

@implementation TestTableViewFooterTitleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.TestTitle.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    
//    self.cellBounds = self.bounds;
    
    [self setNeedsUpdateConstraints];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat inset = 4.0f;
    
    CGRect bounds = self.cellBounds;
    CGRect boundsWithInsets = CGRectMake(bounds.origin.x + inset,
                                         bounds.origin.y,
                                         bounds.size.width - 2 * inset,
                                         bounds.size.height - inset);
    [super setBounds:boundsWithInsets];
}
*/


- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width = self.superview.frame.size.width - 2 * inset;
    frame.size.height = FooterTitleCellHeight - inset;
    
    [super setFrame:frame];
}


@end
