//
//  StringrImageAndTextButton.h
//  Stringr
//
//  Created by Jonathan Howard on 10/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrImageAndTextButton : UIView

@property (weak, nonatomic, readonly) IBOutlet UIButton *socialButton;

- (void)setSocialCount:(NSUInteger)count;
- (void)setSocialCountText:(NSString *)text;
- (NSUInteger)socialCount;

- (void)setImageForSocialButton:(UIImage *)image;
- (void)setSelectedImageForSocialButton:(UIImage *)image;

- (void)setSocialLabelAlpha:(CGFloat)alpha;

@end
