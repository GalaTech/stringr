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
@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *addNewPhotoToStringButton;


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
}

@end
