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

- (void)setImageForSocialButton:(UIImage *)image;

@end
