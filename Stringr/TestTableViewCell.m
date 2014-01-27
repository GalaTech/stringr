//
//  TestTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()



@end

@implementation TestTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
            

    }
    
    
    return self;
}


- (void)setLabel:(UILabel *)label
{
    [self.label setText:@"Test"];
}



@end
