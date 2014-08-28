//
//  StringrObject.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface StringrObject : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *displayName;

+ (NSString *)parseClassName;

@end
