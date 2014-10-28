//
//  StringrImageAndTextButton.m
//  Stringr
//
//  Created by Jonathan Howard on 10/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrImageAndTextButton.h"

@interface StringrImageAndTextButton ()

@property (weak, nonatomic, readwrite) IBOutlet UIButton *socialButton;
@property (weak, nonatomic) IBOutlet UILabel *socialCountLabel;

@end

@implementation StringrImageAndTextButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.socialCountLabel.alpha = 0.0f;
    self.backgroundColor = [UIColor clearColor];
    self.socialButton.backgroundColor = [UIColor clearColor];
    self.socialCountLabel.backgroundColor = [UIColor clearColor];
}


- (void)setImageForSocialButton:(UIImage *)image
{
    [self.socialButton setImage:image forState:UIControlStateNormal];
}


- (void)setSelectedImageForSocialButton:(UIImage *)image
{
    [self.socialButton setImage:image forState:UIControlStateSelected];
}


- (void)setSocialCountText:(NSString *)text
{
    self.socialCountLabel.text = text;
}


- (void)setSocialCount:(NSUInteger)count
{
    NSString *countText = [NSString stringWithFormat:@"%ld", count];
    
    self.socialCountLabel.text = countText;
}


- (NSUInteger)socialCount
{
    return [self.socialCountLabel.text integerValue];
}


- (void)setSocialLabelAlpha:(CGFloat)alpha
{
    self.socialCountLabel.alpha = alpha;
}

@end
