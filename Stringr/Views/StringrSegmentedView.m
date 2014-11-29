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

@interface StringrSegmentedView ()

@property (strong, nonatomic) NSArray *segmentContainers;
@property (strong, nonatomic) NSArray *segmentButtons;

@end

@implementation StringrSegmentedView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame segments:(NSArray *)segments
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _segments = segments;
        
        [self setupSegmentedControl];
    }
    
    return self;
}


- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
//    self.translatesAutoresizingMaskIntoConstraints = NO;
}


- (void)setSegments:(NSArray *)segments
{
    _segments = segments;
    
    [self setupSegmentedControl];
}

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
    }
}


- (NSArray *)setupSegmentButtons
{
    NSMutableArray *segmentContainers = [[NSMutableArray alloc] initWithCapacity:self.segments.count];
    NSMutableArray *segmentButtons = [[NSMutableArray alloc] initWithCapacity:self.segments.count];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) / self.segments.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect segmentFrame = CGRectMake(0.0f, 0.0f, width, height);
    
    for (StringrSegment *segment in self.segments) {
        if ([segment isKindOfClass:[StringrSegment class]]) {
            
            UIView *segmentContainer = [[UIView alloc] initWithFrame:segmentFrame];
            segmentContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat imageViewHeight = height * 0.66;
            
//            UIImageView *segmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, imageViewHeight)];
//            [segmentImageView setImage:segment.image];
//            segmentImageView.contentMode = UIViewContentModeScaleAspectFit;
//            [segmentContainer addSubview:segmentImageView];
            
            CGFloat labelY = height - (height / 3);
            CGFloat labelHeight = (height / 3);
            
            UILabel *segmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY, width, labelHeight)];
            segmentLabel.text = segment.title;
            segmentLabel.textAlignment = NSTextAlignmentCenter;
            segmentLabel.textColor = [UIColor stringrSecondaryLabelColor];
            segmentLabel.font = [UIFont stringrHeaderSecondaryLabelFont];
            [segmentContainer addSubview:segmentLabel];
            
            UIImage *segmentImage = [segment.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

            UIButton *segmentButton = [[UIButton alloc] initWithFrame:segmentFrame];
            [segmentButton addTarget:self action:@selector(segmentTouchedUpInside:)  forControlEvents:UIControlEventTouchUpInside];
            [segmentButton setImage:segmentImage forState:UIControlStateNormal];
            segmentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            segmentButton.tintColor = [UIColor lightGrayColor];
            segmentButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -3.0, 12.0, -3.0f);
            
            [segmentContainer addSubview:segmentButton];
            [segmentContainer bringSubviewToFront:segmentButton];
            
            [segmentContainers addObject:segmentContainer];
            [segmentButtons addObject:segmentButton];
        }
    }
    
    self.segmentButtons = [segmentButtons copy];
    self.segmentContainers = [segmentContainers copy];
    return [segmentContainers copy];
}

- (IBAction)segmentTouchedUpInside:(UIButton *)sender
{
    NSInteger index = [self.segmentButtons indexOfObject:sender];
    
    if ([self.delegate respondsToSelector:@selector(segmentedView:didSelectItemAtIndex:)]) {
        [self.delegate segmentedView:self didSelectItemAtIndex:index];
    }
}

@end


@implementation StringrSegment

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image
{
    StringrSegment *segment = [StringrSegment new];
    segment.title = title;
    segment.image = image;
    
    return segment;
}

@end


@interface StringrSegmentContainer ()

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *label;

@end

@implementation StringrSegmentContainer

@end
