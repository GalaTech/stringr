//
//  TestTableViewFooterCellTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterTitleCell.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"

@interface TestTableViewFooterTitleCell ()

@property (nonatomic) CGRect cellBounds;

@end

@implementation TestTableViewFooterTitleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self setupAppearance];
    
    [self setNeedsUpdateConstraints];

}


- (void)setupAppearance
{
    self.TestTitle.textColor = [UIColor stringrPrimaryLabelColor];
    self.TestTitle.font = [UIFont stringrPrimaryStringTitleLabelFont];
}


- (void)configureFooterCellWithString:(PFObject *)string
{
//    self.TestTitle.text = string[kStringrStringTitleKey];
    self.TestTitle.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width = self.superview.frame.size.width - 2 * inset;
//    frame.size.height = FooterTitleCellHeight - inset;
    
    [super setFrame:frame];
}


@end
