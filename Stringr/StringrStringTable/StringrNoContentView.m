//
//  StringrNoContentView.m
//  Stringr
//
//  Created by Jonathan Howard on 5/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNoContentView.h"
#import "AppDelegate.h"

@interface StringrNoContentView ()

@property (strong,nonatomic) NSString *noContentText;
@property (strong, nonatomic) UILabel *noContentTextLabel;
@property (strong, nonatomic) UIButton *exploreOptionButton;

@end

@implementation StringrNoContentView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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
        self.noContentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLT_MIN, FLT_MIN, 280, labelHeight + 20)];
        self.noContentTextLabel.center = CGPointMake(centerX, centerY);
//        self.noContentTextLabel.backgroundColor = [UIColor greenColor];
        self.noContentTextLabel.text = text;
        [self.noContentTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.noContentTextLabel setTextColor:[UIColor darkGrayColor]];
        [self.noContentTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self.noContentTextLabel setNumberOfLines:2];
        [self addSubview:self.noContentTextLabel];
        
        self.exploreOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(FLT_MIN, FLT_MIN, 280, 35)];
        self.exploreOptionButton.center = CGPointMake(centerX, centerY + 80);
        [self.exploreOptionButton setTitle:@"Explore More" forState:UIControlStateNormal];
        
        [self.exploreOptionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.exploreOptionButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [self.exploreOptionButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateSelected];
        [self.exploreOptionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self.exploreOptionButton addTarget:self action:@selector(exploreMoreButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.exploreOptionButton];

        [self addSubview:[self setupColoredHeaderRibbon]];
        [self setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    }
    
    return self;
}



#pragma mark - Actions

- (void)exploreMoreButtonTouchHandler
{
    if ([self.delegate respondsToSelector:@selector(noContentView:didSelectExploreOptionButton:)]) {
        [self.delegate noContentView:self didSelectExploreOptionButton:self.exploreOptionButton];
    }
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

- (void)setTitleForExploreOptionButton:(NSString *)title
{
    [self.exploreOptionButton setTitle:title forState:UIControlStateNormal];
}



#pragma mark - Private

- (UIView *)setupColoredHeaderRibbon
{
    UIView *headerViewColoredLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, 4.0f)];
    
    CGSize colorBlockSize = CGSizeMake(CGRectGetWidth(headerViewColoredLine.frame) / 7, 3.0f);
    
    for (int i = 0; i < 7; i++) {
        UIImageView *colorBlock = [[UIImageView alloc] initWithFrame:CGRectMake(i * colorBlockSize.width, 0, colorBlockSize.width, colorBlockSize.height)];
        
        UIColor *blockColor = [[UIColor alloc] init];
        switch (i) {
            case 0:
                blockColor = [StringrConstants kStringrRedColor];
                break;
            case 1:
                blockColor = [StringrConstants kStringrOrangeColor];
                break;
            case 2:
                blockColor = [StringrConstants kStringrYellowColor];
                break;
            case 3:
                blockColor = [StringrConstants kStringrGreenColor];
                break;
            case 4:
                blockColor = [StringrConstants kStringrTurquoiseColor];
                break;
            case 5:
                blockColor = [StringrConstants kStringrBlueColor];
                break;
            case 6:
                blockColor = [StringrConstants kStringrPurpleColor];
                break;
            default:
                break;
        }
        
        [colorBlock setBackgroundColor:blockColor];
        [headerViewColoredLine addSubview:colorBlock];
    }
    
    return headerViewColoredLine;
}

@end
