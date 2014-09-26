//
//  StringrNetworkRequests.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringrObject.h"

@interface StringrNetworkRequests : NSObject

+ (void)addObject:(StringrObject *)object;
+ (void)getObjectWithName:(NSString *)name completionBlock:(void (^)(StringrObject *object, BOOL success))completionBlock;

@end
