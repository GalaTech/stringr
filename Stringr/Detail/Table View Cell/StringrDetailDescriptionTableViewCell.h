//
//  StringrDetailDescriptionTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTableViewCell.h"

@interface StringrDetailDescriptionTableViewCell : StringrDetailTableViewCell

- (void)setDescriptionForCell:(NSString *)description;
- (NSDictionary *)getDescriptionTextAttributes;

- (NSString *)getDescriptionText;

@end
