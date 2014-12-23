//
//  StringrNetworkTask+Explore.h
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

@interface StringrNetworkTask (Explore)

+ (void)exploreCategorySections:(void (^)(NSArray *categorySections, NSError *error))completionBlock;

@end
