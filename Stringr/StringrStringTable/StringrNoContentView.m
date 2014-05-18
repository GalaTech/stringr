//
//  StringrNoContentView.m
//  Stringr
//
//  Created by Jonathan Howard on 5/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNoContentView.h"

@interface StringrNoContentView ()

@property (strong,nonatomic) NSString *noContentText;
@property (strong, nonatomic) UILabel *noContentTextLabel;

@end

@implementation StringrNoContentView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float centerX = CGRectGetWidth(frame) / 2;
        float centerY = CGRectGetHeight(frame) / 2;
        
        self.noContentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLT_MIN, FLT_MIN, 280, FLT_MIN)];
        self.noContentTextLabel.center = CGPointMake(centerX, centerY);
        [self.noContentTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.noContentTextLabel setTextColor:[UIColor darkGrayColor]];
        [self.noContentTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self addSubview:self.noContentTextLabel];
        
        [self setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNoContentText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        float centerX = CGRectGetWidth(frame) / 4;
        float centerY = CGRectGetHeight(frame) / 2;
        
        CGFloat labelHeight = [StringrUtility heightForLabelWithNSString:text];
        self.noContentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLT_MIN, FLT_MIN, 280, labelHeight)];
        self.noContentTextLabel.center = CGPointMake(centerX, centerY);
        self.noContentTextLabel.text = text;
        [self.noContentTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.noContentTextLabel setTextColor:[UIColor darkGrayColor]];
        [self.noContentTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self addSubview:self.noContentTextLabel];
        
        [self setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    }
    
    return self;
}


#pragma mark - Public

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
