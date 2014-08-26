//
//  StringrNoContentTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 4/1/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNoContentTableViewCell.h"

@interface StringrNoContentTableViewCell ()

@property (strong,nonatomic) NSString *noContentText;
@property (strong, nonatomic) UILabel *noContentTextLabel;

@end

@implementation StringrNoContentTableViewCell

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float centerX = CGRectGetWidth(self.contentView.frame) / 2;
        float centerY = CGRectGetHeight(self.contentView.frame) / 2;
        
        self.noContentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLT_MIN, FLT_MIN, FLT_MIN, FLT_MIN)];
        self.noContentTextLabel.center = CGPointMake(centerX, centerY);
        self.noContentTextLabel.text = @"There is no content to display!";
        [self.noContentTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.noContentTextLabel setTextColor:[UIColor darkGrayColor]];
        [self.noContentTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self.contentView addSubview:self.noContentTextLabel];
        
        [self setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    }
    
    return self;
}



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)setNoContentTextForCell:(NSString *)text
{
    self.noContentText = text;
    
    CGFloat labelHeight = [StringrUtility heightForLabelWithNSString:text];
    
    CGRect labelFrame = self.noContentTextLabel.frame;
    labelFrame.size.height = labelHeight;
    
    self.noContentTextLabel.frame = labelFrame;
    self.noContentTextLabel.text = text;
}


@end
