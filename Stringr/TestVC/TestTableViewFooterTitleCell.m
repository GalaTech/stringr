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
    self.stringTitle.textColor = [UIColor stringrPrimaryLabelColor];
    self.stringTitle.font = [UIFont stringrPrimaryStringTitleLabelFont];
}


- (void)configureFooterCellWithString:(PFObject *)string
{
    self.stringTitle.text = string[kStringrStringTitleKey];
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
