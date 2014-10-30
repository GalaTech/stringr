//
//  StringrDetailPhotoOwnerTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailPhotoOwnerTableViewCell.h"

@interface StringrDetailPhotoOwnerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *stringOwnerNameLabel;

@end

@implementation StringrDetailPhotoOwnerTableViewCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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


#pragma mark - Public

- (void)setStringOwnerNameForCell:(NSString *)ownerName
{
    [self.stringOwnerNameLabel setText:ownerName];
}

@end
