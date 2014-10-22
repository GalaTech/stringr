//
//  TestTableViewFooterActionCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterActionCell.h"

@interface TestTableViewFooterActionCell ()

@property (nonatomic) CGRect cellBounds;

@end

@implementation TestTableViewFooterActionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.cellBounds = self.frame;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGFloat inset = 4.0f;
//    
//    CGRect bounds = self.cellBounds;
//    CGRect boundsWithInsets = CGRectMake(bounds.origin.x + inset,
//                                         bounds.origin.y,
//                                         bounds.size.width - (2 * inset),
//                                         bounds.size.height - (inset * 3));
//    [super setBounds:boundsWithInsets];
//}


- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width = self.superview.frame.size.width - 2 * inset;
    
    
    
    frame.size.height = FooterActionCellHeight - (inset * 3);
    
    [super setFrame:frame];
}


@end
