//
//  TestTableViewFooterCellTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringTableViewTitleCell.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"

@interface StringTableViewTitleCell ()

@property (strong, nonatomic, readwrite) PFObject *string;

@end

@implementation StringTableViewTitleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupAppearance];
}


- (void)setupAppearance
{
    self.stringTitle.textColor = [UIColor stringrPrimaryLabelColor];
    self.stringTitle.font = [UIFont stringrPrimaryStringTitleLabelFont];
}


- (void)configureFooterCellWithString:(PFObject *)string
{
    self.string = string;
    self.stringTitle.text = string[kStringrStringTitleKey];
}


- (void)setFrame:(CGRect)frame
{
    // Adds inset to the cell size so that it doesn't fill the full screen width
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width = self.superview.frame.size.width - 2 * inset;
    
    [super setFrame:frame];
}


@end
