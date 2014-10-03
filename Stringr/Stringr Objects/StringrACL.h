//
//  StringrACL.h
//  Stringr
//
//  Created by Jonathan Howard on 9/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrACL : NSObject

+ (StringrACL *)ACL;
+ (StringrACL *)ACLWithUser:(StringrUser *)user;

+ (void)setDefaultACL:(StringrACL *)ACL withAccessForCurrentUser:(StringrUser *)user;


#pragma mark - Set/Get Read Access

- (void)setPublicReadAccess:(BOOL)allowed;
- (BOOL)getPublicReadAccess;

- (void)setReadAccess:(BOOL)allowed forUser:(StringrUser *)user;
- (BOOL)getReadAccessForUser:(StringrUser *)user;


#pragma mark - Set/Get WriteAccess

- (void)setPublicWriteAccess:(BOOL)allowed;
- (BOOL)getPublicWriteAccess;

- (void)setWriteAccess:(BOOL)allowed forUser:(StringrUser *)user;
- (BOOL)getWriteAccessForUser:(StringrUser *)user;


@end
