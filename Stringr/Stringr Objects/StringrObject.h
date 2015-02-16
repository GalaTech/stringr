//
//  StringrObject.h
//  Stringr
//
//  Created by Jonathan Howard on 2/5/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringrACL;

@protocol StringrObject <NSObject>

@required

@property (copy, nonatomic, readonly) NSString *parseClassName;
@property (copy, nonatomic, readonly) NSString *objectID;
@property (strong, nonatomic, readonly) NSDate *updatedAt;
@property (strong, nonatomic, readonly) NSDate *createdAt;

@end
