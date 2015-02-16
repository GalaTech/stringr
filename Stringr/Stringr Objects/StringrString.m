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
        self.parseString = object;
    }
    
    return self;
}


+(instancetype)stringWithObject:(PFObject *)object
{
    return [[StringrString alloc] initWithObject:object];
}


#pragma mark - Accessors - Setters

- (void)setParseString:(PFObject *)parseString
{
    _parseString = [StringrUtility stringFromObject:parseString];
}


#pragma mark - Accessors - Getters

- (PFUser *)uploader
{
    return self.parseString[kStringrStringUserKey];
}


- (NSString *)title
{
    return self.parseString[kStringrStringTitleKey];
}


- (NSInteger)likeCount
{
    PFObject *statistics = self.parseString[@"stringStatistics"];
    return [statistics[kStringrStatisticsLikeCountKey] integerValue];
}


- (NSInteger)commentCount
{
    PFObject *statistics = self.parseString[@"stringStatistics"];
    return [statistics[kStringrStatisticsCommentCountKey] integerValue];
}


- (PFObject *)parseStatistics
{
    return self.parseString[@"stringStatistics"];
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


#pragma mark - <StringrObject>

- (NSString *)parseClassName
{
    return self.parseString.parseClassName;
}


- (NSString *)objectID
{
    return self.parseString.objectId;
}


- (NSDate *)updatedAt
{
    return self.parseString.updatedAt;
}


- (NSDate *)createdAt
{
    return self.parseString.createdAt;
}

@end
