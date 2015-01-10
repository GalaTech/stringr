//
//  StringrString.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrString.h"

@implementation StringrString

#pragma mark - Lifecycle

- (instancetype)initWithObject:(PFObject *)object
{
    self = [super init];
    
    if (self) {
        _string = object;
    }
    
    return self;
}


+(instancetype)stringWithObject:(PFObject *)object
{
    return [[StringrString alloc] initWithObject:object];
}


#pragma mark - Accessors - Setters

- (void)setString:(PFObject *)string
{
    _string = [StringrUtility stringFromObject:string];
}


#pragma mark - Accessors - Getters

- (PFUser *)uploader
{
    return self.string[kStringrStringUserKey];
}


- (NSString *)title
{
    return self.string[kStringrStringTitleKey];
}


- (NSDate *)createdAt
{
    return self.string.createdAt;
}


- (NSDate *)updatedAt
{
    return self.string.updatedAt;
}


#pragma mark - Public

+ (NSArray *)stringsFromArray:(NSArray *)array
{
    NSMutableArray *stringsArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (id object in array) {
        if ([object isKindOfClass:[PFObject class]]) {
            StringrString *string = [StringrString stringWithObject:object];
            
            if (string) [stringsArray addObject:string];
        }
    }
    
    return [stringsArray copy];
}

@end
