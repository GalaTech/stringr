//
//  TestTableViewHeader.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewHeader.h"

@implementation TestTableViewHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
    }
    
    return self;
}


- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}


@end
