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
    _uploader = self.parseString[kStringrStringUserKey];
    return _uploader;
}


- (NSString *)title
{
    _title = self.parseString[kStringrStringTitleKey];
    return _title;
}


- (NSInteger)likeCount
{
    PFObject *statistics = self.parseString[@"stringStatistics"];
    _likeCount = [statistics[kStringrStatisticsLikeCountKey] integerValue];
    return _likeCount;
}


- (NSInteger)commentCount
{
    PFObject *statistics = self.parseString[@"stringStatistics"];
    _commentCount = [statistics[kStringrStatisticsCommentCountKey] integerValue];
    return _commentCount;
}


- (PFObject *)parseStatistics
{
    _parseStatistics = self.parseString[@"stringStatistics"];
    return _parseStatistics;
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
