//
//  StringrString.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"

@interface StringrString : StringrObject

@property (strong, nonatomic) PFObject *string;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) PFUser *uploader;
@property (copy, nonatomic) NSString *category;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSArray *likers;

- (instancetype)initWithObject:(PFObject *)object;
- (instancetype)init __attribute__ ((unavailable("[-init] is not allowed, use [-initWithObject:]")));

+ (instancetype)stringWithObject:(PFObject *)object;
+ (instancetype)new __attribute__ ((unavailable("[+new] is not allowed, use [+stringWithObject:]")));

+ (NSArray *)stringsFromArray:(NSArray *)array;

@end
