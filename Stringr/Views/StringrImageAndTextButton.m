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
    
}


- (void)setImageForSocialButton:(UIImage *)image
{
    self.socialButton.imageView.image = image;
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

@end
