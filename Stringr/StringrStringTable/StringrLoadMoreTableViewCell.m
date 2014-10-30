//
//  StringrLoadMore.m
//  Stringr
//
//  Created by Jonathan Howard on 4/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrLoadMoreTableViewCell.h"
#import "UIColor+StringrColors.h"

@implementation StringrLoadMoreTableViewCell

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setBackgroundColor:[UIColor stringrLightGrayColor]];
        
        NSString *loadMoreText = @"Load More";
        
        UILabel *loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
        [loadMoreLabel setText:loadMoreText];
        [loadMoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [loadMoreLabel setTextColor:[UIColor whiteColor]];
        [loadMoreLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat xPosition = CGRectGetWidth(self.frame) / 2;
        CGFloat yPosition = CGRectGetHeight(self.frame) / 2;
        
        [loadMoreLabel setCenter:CGPointMake(xPosition, yPosition)];
        
        [self addSubview:loadMoreLabel];
    }
    
    
    return self;
}


@end
