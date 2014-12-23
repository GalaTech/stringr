//
//  StringrTableSection.h
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrTableSection : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *sectionRows;

- (void)addRow:(id)object;

@end
