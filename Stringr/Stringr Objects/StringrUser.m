//
//  StringrUser.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrUser.h"

@implementation StringrUser

#pragma mark - <StringrObject>

- (NSString *)parseClassName
{
    return self.parseUser.parseClassName;
}


- (NSString *)objectID
{
    return self.parseUser.objectId;
}


- (NSDate *)updatedAt
{
    return self.parseUser.updatedAt;
}


- (NSDate *)createdAt
{
    return self.parseUser.createdAt;
}

@end
