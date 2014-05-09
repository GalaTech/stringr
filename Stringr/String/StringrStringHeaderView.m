//
//  StringrStringHeaderView.m
//  Stringr
//
//  Created by Jonathan Howard on 5/6/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringHeaderView.h"

@interface StringrStringHeaderView ()

@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) NSString *titleText;


@end

@implementation StringrStringHeaderView

// Percentage for the width of the content header view
static float const contentViewWidthPercentage = .93;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.alpha = 1.0f;
        
        float xpoint = (320 - (frame.size.width * contentViewWidthPercentage)) / 2;
        CGRect contentHeaderRect = CGRectMake(xpoint, 0, frame.size.width * contentViewWidthPercentage, 23.5);
        
        // This is the content view, which is a button that will provide user interaction that can take them to
        // the detail view of a string
        self.headerButton = [[UIButton alloc] initWithFrame:contentHeaderRect];
        [self.headerButton setBackgroundColor:[UIColor whiteColor]];
        self.headerButton.backgroundColor = [UIColor whiteColor];
        [self.headerButton addTarget:self action:@selector(pushToStringDetailView) forControlEvents:UIControlEventTouchUpInside];
        [self.headerButton setAlpha:0.92];
        // Sets tag so we can easily access the correct string when a user taps the detail view for a string
        [self.headerButton setTag:self.section];
        
        [self.headerButton setTitle:@"" forState:UIControlStateNormal];
        [self.headerButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.headerButton.titleLabel setMinimumScaleFactor:0.5f];
        [self.headerButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.headerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.headerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
        
        [self addSubview:self.headerButton];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Public

- (void)setStringForHeader:(PFObject *)stringForHeader
{
    _stringForHeader = stringForHeader;
    
    PFObject *string = _stringForHeader;
    if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [string objectForKey:kStringrStatisticsStringKey];
    } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [string objectForKey:kStringrActivityStringKey];
    }
    
    [self.headerButton setTitle:[string objectForKey:kStringrStringTitleKey] forState:UIControlStateNormal];
}

- (void)setStringEditingEnabled:(BOOL)stringEditingEnabled
{
    UIColor *editingEnabledRedColor = [StringrConstants kStringrHandleColor];
    if (stringEditingEnabled) {
        [self.headerButton setTitleColor:editingEnabledRedColor forState:UIControlStateNormal];
    } else {
        [self.headerButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

- (void)pushToStringDetailView
{
    if ([self.delegate respondsToSelector:@selector(headerView:pushToStringDetailViewWithString:)]) {
        [self.delegate headerView:self pushToStringDetailViewWithString:self.stringForHeader];
    }
}


@end
