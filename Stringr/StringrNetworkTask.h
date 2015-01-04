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

typedef enum {
    StringrFollowingNetworkTask = 0,
    StringrMyStringrNetworkTask
} StringrNetworkStringTaskType;

typedef enum {
    StringrUserPhotosNetworkTask = 0,
    StringrUserPublicPhotosNetworkTask
} StringrNetworkPhotoTaskType;

typedef void (^StringrStringsBlock)(NSArray *strings, NSError *error);
typedef void (^StringrPhotosBlock)(NSArray *photos, NSError *error);

@interface StringrNetworkTask : NSObject

+ (StringrObjectType)objectType:(PFObject *)object;

+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType completion:(StringrStringsBlock)completion;

+ (void)photosForDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user completion:(StringrPhotosBlock)completion;

@end
