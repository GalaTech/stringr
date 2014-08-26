//
//  StringrSelectProfileImageTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 2/26/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSelectProfileImageTableViewCell.h"
#import "StringrPathImageView.h"

@implementation StringrSelectProfileImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.userProfileImage setImageToCirclePath];
        [self.userProfileImage setPathWidth:1.0];
        [self.userProfileImage setPathColor:[UIColor darkGrayColor]];
        [self.userProfileImage setImage:[UIImage imageNamed:@"stringr_icon_filler"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
