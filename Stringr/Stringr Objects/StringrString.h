//
//  StringrString.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"

@class StringrExploreCategory;

@interface StringrString : NSObject <StringrObject>

@property (strong, nonatomic) PFObject *parseString;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) PFUser *uploader;
@property (copy, nonatomic) StringrExploreCategory *category;

@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) BOOL isLikedByCurrentUser;

@property (strong, nonatomic) PFObject *parseStatistics;

- (instancetype)initWithObject:(PFObject *)object;
- (instancetype)init __attribute__ ((unavailable("[-init] is not allowed, use [-initWithObject:]")));

+ (instancetype)stringWithObject:(PFObject *)object;
+ (instancetype)new __attribute__ ((unavailable("[+new] is not allowed, use [+stringWithObject:]")));

+ (NSArray *)stringsFromArray:(NSArray *)array;

@end
