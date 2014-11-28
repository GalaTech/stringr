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

@interface StringrSegmentedView ()

@property (strong, nonatomic, readwrite) NSArray *segments;

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
}


- (void)setupSegmentedControl
{
    NSArray *segmentButtons = [self segmentButtons];
    
    for (NSInteger index = 0; index < segmentButtons.count; index++) {
        UIView *segment = segmentButtons[index];
        CGFloat width = CGRectGetWidth(segment.frame);
        
        CGRect segmentFrame = segment.frame;
        segmentFrame.origin.x = width * index;
        
        segment.frame = segmentFrame;

        [self addSubview:segment];
    }
}


- (NSArray *)segmentButtons
{
    NSMutableArray *segmentButtons = [[NSMutableArray alloc] initWithCapacity:self.segments.count];
    
    CGFloat width = CGRectGetWidth(self.frame) / self.segments.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect segmentFrame = CGRectMake(0.0f, 0.0f, width, height);
    
    for (StringrSegment *segment in self.segments) {
        if ([segment isKindOfClass:[StringrSegment class]]) {
            
            UIView *segmentContainer = [[UIView alloc] initWithFrame:segmentFrame];
            segmentContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat imageViewHeight = height * 0.66;
            
            UIImageView *segmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, imageViewHeight)];
            [segmentImageView setImage:segment.image];
            segmentImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [segmentContainer addSubview:segmentImageView];
            
            CGFloat labelY = height - (height / 3);
            CGFloat labelHeight = (height / 3);
            
            UILabel *segmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelY, width, labelHeight)];
            segmentLabel.text = segment.title;
            segmentLabel.textAlignment = NSTextAlignmentCenter;
            segmentLabel.textColor = [UIColor stringrSecondaryLabelColor];
            segmentLabel.font = [UIFont stringrHeaderSecondaryLabelFont];
            segmentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [segmentContainer addSubview:segmentLabel];
            
            UIButton *segmentButton = [[UIButton alloc] initWithFrame:segmentFrame];
            [segmentButton addTarget:self action:@selector(segmentTapped) forControlEvents:UIControlEventTouchUpInside];
            segmentButton.translatesAutoresizingMaskIntoConstraints = NO;
            [segmentContainer addSubview:segmentButton];
            [segmentContainer bringSubviewToFront:segmentButton];
        }
    }
    
    return [segmentButtons copy];
}


- (void)segmentTapped
{
    NSLog(@"tapped segment");
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
