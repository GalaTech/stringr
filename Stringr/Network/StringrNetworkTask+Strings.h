//
//  StringrNetworkTask+Strings.h
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

typedef enum {
    StringrFollowingNetworkTask = 0,
    StringrUserStringsNetworkTask,
    StringrLikedStringsNetworkTask
} StringrNetworkStringTaskType;

typedef void (^StringrStringsBlock)(NSArray *strings, NSError *error);


@interface StringrNetworkTask (Strings)

+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType completion:(StringrStringsBlock)completion;
+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrStringsBlock)completion;

+ (void)homeFeedForUser:(PFUser *)user completion:(StringrStringsBlock)completion;

@end
