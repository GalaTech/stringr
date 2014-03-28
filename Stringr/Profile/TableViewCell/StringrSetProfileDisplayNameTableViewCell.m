//
//  StringrSetProfileDisplayNameTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSetProfileDisplayNameTableViewCell.h"

@implementation StringrSetProfileDisplayNameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - IBAction's
- (IBAction)fieldErrorButtonTouchHandler:(UIButton *)sender
{
    UIAlertView *invalidUsernameAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid Username" message:@"Your username must consist of letters, numbers, periods, hypehns, or underscores and be less than 15 characters in length." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [invalidUsernameAlertView show];
}

@end
