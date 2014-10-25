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
@property (weak, nonatomic, readwrite) IBOutlet UILabel *socialCountLabel;

@end

@implementation StringrImageAndTextButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"test");
}


@end
