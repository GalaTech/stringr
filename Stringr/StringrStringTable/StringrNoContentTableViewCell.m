//
//  StringrNoContentTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 4/1/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNoContentTableViewCell.h"

@implementation StringrNoContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
