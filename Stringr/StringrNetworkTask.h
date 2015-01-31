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


@interface StringrNetworkTask : NSObject

+ (StringrObjectType)objectType:(PFObject *)object;

@end
