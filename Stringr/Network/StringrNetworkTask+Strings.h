//
//  StringrNetworkTask+Strings.h
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@class StringrExploreCategory;

typedef enum {
    StringrFollowingNetworkTask = 0,
    StringrUserStringsNetworkTask,
    StringrLikedStringsNetworkTask,
    StringrExploreCategoryNetworkTask
} StringrNetworkStringTaskType;

typedef void (^StringrStringsBlock)(NSArray *strings, NSError *error);


@interface StringrNetworkTask (Strings)

- (void)stringCountForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrCountBlock)completion;
- (void)stringCountForCategory:(StringrExploreCategory *)category user:(PFUser *)user completion:(StringrCountBlock)completion;

- (void)stringsForDataType:(StringrNetworkStringTaskType)dataType completion:(StringrStringsBlock)completion;
- (void)stringsForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrStringsBlock)completion;
- (void)stringsForDataType:(StringrNetworkStringTaskType)dataType target:(id)target selector:(SEL)selector;

- (void)stringsForCategory:(StringrExploreCategory *)category completion:(StringrStringsBlock)completion;
- (void)stringsForCategory:(StringrExploreCategory *)category target:(id)target selector:(SEL)selector;

@end
