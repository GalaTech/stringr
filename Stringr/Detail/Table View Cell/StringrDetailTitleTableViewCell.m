//
//  StringrDetailTitleTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTitleTableViewCell.h"

@interface StringrDetailTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StringrDetailTitleTableViewCell

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
    [self.titleLabel setNumberOfLines:200];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




#pragma mark - Public

- (void)setTitleForCell:(NSString *)title
{
    [self.titleLabel setText:title];
    [self.titleLabel setTextColor:[UIColor darkGrayColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
}

@end
