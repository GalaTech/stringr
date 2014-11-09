//
//  StringrNoContentView.m
//  Stringr
//
//  Created by Jonathan Howard on 5/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNoContentView.h"
#import "StringrAppDelegate.h"
#import "UIColor+StringrColors.h"

@interface StringrNoContentView ()

@property (strong,nonatomic) NSString *noContentText;
@property (strong, nonatomic) UILabel *noContentTextLabel;
@property (strong, nonatomic) UIButton *exploreOptionButton;

@end

@implementation StringrNoContentView

#pragma mark - Lifecycle

- (instancetype)initWithNoContentText:(NSString *)text
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 2, 200.0f) andNoContentText:text];
}

/**
 * @brief This will setup a view that contains a centered label with the inputted text.
 * @param frame The frame rectangle for the view, measured in points. The origin of the frame
 * is relative to the superview in which you plan to add it. This method uses the frame rectangle
 * to set the center and bounds properties accordingly.
 * @param text The text for the centered UILabel that is contained within this view. The label's height
 * will dynamically change based around the amount of text provided.
 * @return An initialized NoContentView object with set text or nil if the object couldn't be created.
 */
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
        
        UIColor *lightGrayBlueColor = [UIColor colorWithRed:155.0/255.0f green:168.0/255.0f blue:185.0/255.0f alpha:1.0];
        
        [self.exploreOptionButton setTitleColor:lightGrayBlueColor forState:UIControlStateNormal];
        [self.exploreOptionButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [self.exploreOptionButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateSelected];
        [self.exploreOptionButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self.exploreOptionButton addTarget:self action:@selector(exploreMoreButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.exploreOptionButton setUserInteractionEnabled:NO]; // Is set to yes when a title is set for the button
        [self addSubview:self.exploreOptionButton];

        [self addSubview:[self setupColoredHeaderRibbon]];
        [self setBackgroundColor:[UIColor stringrLightGrayColor]];
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
    [self.exploreOptionButton setUserInteractionEnabled:YES];
}



#pragma mark - Private

- (UIView *)setupColoredHeaderRibbon
{
    UIView *headerViewColoredLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, 2.0f)];
    
    CGSize colorBlockSize = CGSizeMake(CGRectGetWidth(headerViewColoredLine.frame) / 7, 2.0f);
    
    for (int i = 0; i < 7; i++) {
        UIImageView *colorBlock = [[UIImageView alloc] initWithFrame:CGRectMake(i * colorBlockSize.width, 0, colorBlockSize.width, colorBlockSize.height)];
        
        UIColor *blockColor = [[UIColor alloc] init];
        switch (i) {
            case 0:
                blockColor = [UIColor stringrLogoRedColor];
                break;
            case 1:
                blockColor = [UIColor stringrLogoOrangeColor];
                break;
            case 2:
                blockColor = [UIColor stringrLogoYellowColor];
                break;
            case 3:
                blockColor = [UIColor stringrLogoGreenColor];
                break;
            case 4:
                blockColor = [UIColor stringrLogoTurquoiseColor];
                break;
            case 5:
                blockColor = [UIColor stringrLogoBlueColor];
                break;
            case 6:
                blockColor = [UIColor stringrLogoPurpleColor];
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
