//
//  TestTableViewStringCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewStringCell.h"

@implementation TestTableViewStringCell

- (instancetype)init
{
    self = [super init];
    
    if (self) {
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.layer.shadowOpacity = 0.5f;
//        self.layer.shadowPath = shadowPath.CGPath;
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
