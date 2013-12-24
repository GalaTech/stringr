//
//  StringrFooterContentView.m
//  Stringr
//
//  Created by Jonathan Howard on 12/24/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrFooterContentView.h"

@implementation StringrFooterContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"StringrFooterView" owner:self options:nil];
        UIView *mainView = (UIView *)[nibViews objectAtIndex:0];
        [self addSubview:mainView];
        
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

- (IBAction)testSwitch:(UISwitch *)sender
{
    NSLog(@"Switch");
}



@end
