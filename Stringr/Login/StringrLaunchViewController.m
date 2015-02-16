//
//  StringrLaunchViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/8/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrLaunchViewController.h"


@interface StringrLaunchViewController ()

@end

@implementation StringrLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *stringrImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    stringrImageView.image = [UIImage imageNamed:@"stringr_logo"];
    stringrImageView.translatesAutoresizingMaskIntoConstraints = NO;
    stringrImageView.alpha = 0.0f;
    
    [self.view addSubview:stringrImageView];
    
    CGFloat width = self.view.frame.size.width / 1.25;
    CGFloat height = width * 87/241;
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:stringrImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:width], [NSLayoutConstraint constraintWithItem:stringrImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:height], [NSLayoutConstraint constraintWithItem:stringrImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:stringrImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f]]];
    
    
    [UIView animateWithDuration:0.66 animations:^{
        stringrImageView.alpha = 1.0f;
    }];
}

@end
