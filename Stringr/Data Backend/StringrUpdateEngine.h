//
//  StringrUpdateEngine.h
//  Stringr
//
//  Created by Jonathan Howard on 10/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrUpdateEngine : NSObject

+ (instancetype)sharedEngine;

- (void)start;
- (void)stop;

- (void)refreshAll;

@end
