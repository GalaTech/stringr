//
//  StringFooterTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringFooterTableViewCell.h"
#import "StringrFooterContentView.h"

#import "GBPathImageView.h"


@interface StringFooterTableViewCell ()

@property (strong, nonatomic) UILabel *testLabel;
@property (strong, nonatomic) UIImageView *testImageView;

@property (strong, nonatomic) UIButton *testButton;

@end

@implementation StringFooterTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        // Sets background to same tableview bg color
        UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [self.contentView setBackgroundColor:veryLightGrayColor];

        // Creates the custom footer content view
        UIView *contentFooterView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.contentView.frame.size.width * .875, 35)];
        [contentFooterView setBackgroundColor:[UIColor whiteColor]];
        [contentFooterView setAlpha:1];
        
        
        UIButton *commentsButton = [self commentsButtonWithTitle];
        [contentFooterView addSubview:commentsButton];
        
        UIButton *likesButton = [self likesButtonWithTitle];
        [contentFooterView addSubview:likesButton];
        
        
        self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 18)];
        [self.testLabel setText:@"55.7k"];
        [self.testLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
        [self.testLabel setTextColor:[UIColor grayColor]];
        [self.testLabel setTextAlignment:NSTextAlignmentRight];
        //[self.testLabel setBackgroundColor:[UIColor yellowColor]];
        [contentFooterView addSubview:self.testLabel];
        
        self.testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 1.5, 17, 15)];
        [self.testImageView setImage:[UIImage imageNamed:@"comment-bubble.png"]];
        [contentFooterView addSubview:self.testImageView];
        
        self.testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 18)];
        [self.testButton addTarget:self action:@selector(pushDownButton) forControlEvents:UIControlEventTouchDown];
        [self.testButton addTarget:self action:@selector(pushButton) forControlEvents:UIControlEventTouchUpInside];
        //[self.testButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
        [contentFooterView addSubview:self.testButton];
        
        [self.contentView addSubview:contentFooterView];
        
        
    }
    
    return self;
}

- (void)pushButton
{
    self.testLabel.textColor = [UIColor grayColor];
    
}

- (void)pushDownButton
{
    self.testLabel.textColor = [UIColor darkGrayColor];
}

- (NSString *)commentButtonTitle
{
    return @"4.4k";
}

- (NSString *)likeButtonTitle
{
    return @"97";
}



- (UIButton *)likesButtonWithTitle
{
    CGRect buttonFrame = CGRectMake(280 * .72, 7.3, 45, 18);
    UIButton *likesButton = [[UIButton alloc] initWithFrame:buttonFrame];
    //[likesButton setBackgroundColor:[UIColor yellowColor]];
    
    UIImage *likeImage = [UIImage imageNamed:@"like-bubble.png"];
    
    [likesButton setImage:[UIImage imageNamed:@"like-bubble.png"] forState:UIControlStateNormal];
    [likesButton setImageEdgeInsets:UIEdgeInsetsMake(0, 29, 2, 0)];
    
    
    int titleInsetSpacing;
    switch ([self.likeButtonTitle length]) {
        case 1:
            titleInsetSpacing = -44;
            break;
        case 2:
            titleInsetSpacing = -49;
            break;
        case 3:
            titleInsetSpacing = -52;
            break;
        case 4:
            titleInsetSpacing = -54;
            break;
        default:
            titleInsetSpacing = -49;
            break;
    }
    
    [likesButton setTitleEdgeInsets:UIEdgeInsetsMake(3, titleInsetSpacing, 0, 0)];
    [likesButton setTitle:self.likeButtonTitle forState:UIControlStateNormal];
    likesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [likesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [likesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    return likesButton;
}

- (UIButton *)commentsButtonWithTitle
{
    CGRect buttonFrame = CGRectMake(280 * .52, 8.5, 45, 18);
    UIButton *commentsButton = [[UIButton alloc] initWithFrame:buttonFrame];
    //[testButton setBackgroundColor:[UIColor purpleColor]];
    [commentsButton setImage:[UIImage imageNamed:@"comment-bubble.png"] forState:UIControlStateNormal];
    [commentsButton setImageEdgeInsets:UIEdgeInsetsMake(1, 28, 2, 0)];
    
    
    int titleInsetSpacing;
    switch ([self.commentButtonTitle length]) {
        case 1:
            titleInsetSpacing = -45;
            break;
        case 2:
            titleInsetSpacing = -50;
            break;
        case 3:
            titleInsetSpacing = -53;
            break;
        case 4:
            titleInsetSpacing = -55;
            break;
        default:
            titleInsetSpacing = -50;
            break;
    }
    
    [commentsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, titleInsetSpacing, 0, 0)];
    [commentsButton setTitle:self.commentButtonTitle forState:UIControlStateNormal];
    commentsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [commentsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [commentsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    return commentsButton;
}



 

@end
