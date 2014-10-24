//
//  StringrNetworkTask+LikeActivity.h
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@interface StringrNetworkTask (LikeActivity)

// Like/Unlike
+ (void)likeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

@end
