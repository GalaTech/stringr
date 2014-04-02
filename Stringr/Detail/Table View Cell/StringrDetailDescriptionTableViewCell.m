//
//  StringrDetailDescriptionTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailDescriptionTableViewCell.h"

@interface StringrDetailDescriptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation StringrDetailDescriptionTableViewCell

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

- (void)setDescriptionForCell:(NSString *)description
{
    [self.descriptionTextView setText:description];
}

@end
