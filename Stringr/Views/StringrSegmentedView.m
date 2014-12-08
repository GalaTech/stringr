//
//  StringrSegmentedView.m
//  Stringr
//
//  Created by Jonathan Howard on 11/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSegmentedView.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"
#import "UIImage+StringrImageAdditions.h"

static CGFloat const StringrSegmentDividerWidth = 2.0f;
static CGFloat const StringrSegmentDividerHeightPercentage = 0.75f;

@interface StringrSegmentedView ()

@property (strong, nonatomic) NSArray *segmentContainers;

@end

@implementation StringrSegmentedView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame segments:(NSArray *)segments
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _segments = segments;
        _selectedSegmentIndex = 0;
        
        [self setupSegmentedControl];
    }
    
    return self;
}


- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _selectedSegmentIndex = 0;
    }
    
    return self;
}


- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Accessors

- (void)setSegments:(NSArray *)segments
{
    _segments = segments;
    
    [self setupSegmentedControl];
}


#pragma mark - Control Events

- (IBAction)segmentTouchedUpInside:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    if (index != self.selectedSegmentIndex) {
        [self updateSelectedIndexButton:sender];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


- (IBAction)segmentTouchedDown:(UIButton *)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}


#pragma mark - Public

- (StringrSegment *)selectedSegment
{
    return self.segments[self.selectedSegmentIndex];
}

#pragma mark - Private

- (void)setupSegmentedControl
{
    NSArray *segmentButtons = [self setupSegmentButtons];
    
    for (NSInteger index = 0; index < segmentButtons.count; index++) {
        UIView *segment = segmentButtons[index];
        CGFloat width = CGRectGetWidth(segment.frame);
        
        CGRect segmentFrame = segment.frame;
        segmentFrame.origin.x = width * index;
        
        segment.frame = segmentFrame;

        [self addSubview:segment];
        
        if (index == segmentButtons.count - 1) continue;
        
        UIImageView *separatorView = [UIImageView new];
        
        CGFloat separatorX = CGRectGetMaxX(segmentFrame) - 1.0f;
        CGFloat separatorY = (CGRectGetHeight(segmentFrame) / 3) / 2;
        CGFloat separatorHeight = CGRectGetHeight(segmentFrame) * 0.66f;
        
        CGRect separatorRect = CGRectMake(separatorX, separatorY, 1.0f, separatorHeight);
        separatorView.frame = separatorRect;
        
        separatorView.backgroundColor = [UIColor stringrLightGrayColor];
        
        [self addSubview:separatorView];
    }
}


- (NSArray *)setupSegmentButtons
{
    NSMutableArray *segmentContainers = [[NSMutableArray alloc] initWithCapacity:self.segments.count];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) / self.segments.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect segmentFrame = CGRectMake(0.0f, 0.0f, width, height);
    
    for (NSInteger index = 0; index < self.segments.count; index++) {
        StringrSegment *segment = self.segments[index];
        
        if ([segment isKindOfClass:[StringrSegment class]]) {
            
            UIView *segmentContainer = [[UIView alloc] initWithFrame:segmentFrame];
            segmentContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat labelY = height - height * 0.4;
            CGFloat labelHeight = (height / 3);
            
            UILabel *segmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY, width, labelHeight)];
            segmentLabel.text = segment.title;
            segmentLabel.textAlignment = NSTextAlignmentCenter;
            segmentLabel.textColor = [UIColor stringrSecondaryLabelColor];
            segmentLabel.font = [UIFont stringrProfileSegmentFont];
            [segmentContainer addSubview:segmentLabel];
            
            UIImage *segmentImage = [UIImage imageNamed:segment.imageName];
            UIImage *segmentImageHighlighted = [UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", segmentImage]];

            UIButton *segmentButton = [[UIButton alloc] initWithFrame:segmentFrame];
            [segmentButton addTarget:self action:@selector(segmentTouchedUpInside:)  forControlEvents:UIControlEventTouchUpInside];
            [segmentButton setImage:segmentImage forState:UIControlStateNormal];
            [segmentButton setImage:segmentImageHighlighted forState:UIControlStateHighlighted];
            segmentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            if (index == self.selectedSegmentIndex) {
//                segmentButton.backgroundColor = [UIColor grayColor];
            }
            else {
                segmentButton.backgroundColor = [UIColor clearColor];
            }
            segmentButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -3.0, 15.0, -3.0f);
            segmentButton.tag = index;
            
            [segmentContainer addSubview:segmentButton];
            [segmentContainer bringSubviewToFront:segmentButton];
            [segmentContainer bringSubviewToFront:segmentLabel];
            [segmentContainers addObject:segmentContainer];
        }
    }
    
    self.segmentContainers = [segmentContainers copy];
    return [segmentContainers copy];
}


- (void)updateSelectedIndexButton:(UIButton *)selectedView
{
    UIView *previouslySelectedViewContainer = self.segmentContainers[self.selectedSegmentIndex];
    UIButton *previouslySelectedButton = nil;
    for (UIView *button in previouslySelectedViewContainer.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            previouslySelectedButton = (UIButton *)button;
        }
    }
    
    previouslySelectedButton.backgroundColor = [UIColor clearColor];
    
    self.selectedSegmentIndex = selectedView.tag;
}


@end


@implementation StringrSegment
@end
