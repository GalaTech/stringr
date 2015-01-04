//
//  StringrNetworkTask+Search.h
//  Stringr
//
//  Created by Jonathan Howard on 12/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@interface StringrNetworkTask (Search)

+ (void)searchForUser:(NSString *)searchText completion:(void (^)(NSArray *users, NSError *error))completion;
+ (void)searchForTag:(NSString *)searchText completion:(void (^)(NSArray *tags, NSError *error))completion;

+ (void)stringsForTag:(PFObject *)tag completion:(void (^)(NSArray *strings, NSError *error))completion;
+ (void)photosForTag:(PFObject *)tag completion:(void (^)(NSArray *photos, NSError *error))completion;

@end
