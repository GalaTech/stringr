//
//  StringrNetworkRequests.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StringrUserType = 0,
    StringrStringType,
    StringrPhotoType,
    StringrCommentType,
    StringrFollowType,
    StringrLikeType,
    StringrContributedType,
    StringrMentionType,
    StringrNoType
} StringrObjectType;

typedef NS_ENUM(NSInteger, StringrNetworkTaskQueryType) {
    StringrNetworkTaskStandardQuery = 0,
    StringrNetworkTaskCountQuery
};

typedef enum {
    StringrNetworkTaskUpdatedAt = 0,
    StringrNetworkTaskCreatedAt
} StringrNetworkTaskOrderType;

typedef void(^StringrCountBlock)(NSInteger count, NSError *error);

@interface StringrNetworkTask : NSObject

@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger skip;
@property (nonatomic) StringrNetworkTaskOrderType orderBy;
@property (nonatomic) BOOL resultsAreAscending;

+ (StringrObjectType)objectType:(PFObject *)object;

@end
