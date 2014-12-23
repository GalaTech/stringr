//
//  StringrTableSection.m
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrTableSection.h"

@interface StringrTableSection ()

//@property (strong, nonatomic) NSMutableArray *sectionRows;

@end

@implementation StringrTableSection


#pragma mark - Accessors

- (NSMutableArray *)sectionRows
{
    if (!_sectionRows) {
        _sectionRows = [[NSMutableArray alloc] init];
    }
    
    return _sectionRows;
}


#pragma  mark - Public

- (void)addRow:(id)object
{
//    self.sec
}

@end
