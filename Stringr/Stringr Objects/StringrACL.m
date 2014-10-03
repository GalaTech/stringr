//
//  StringrACL.m
//  Stringr
//
//  Created by Jonathan Howard on 9/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrACL.h"

@interface NSMutableDictionary (StringrACLReadWrite)

@property (nonatomic) BOOL readAccess;
@property (nonatomic) BOOL writeAccess;

@end

@implementation NSMutableDictionary (StringrACLReadWrite)



- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.readAccess = NO;
        self.writeAccess = NO;
    }
    
    return self;
}

+ (NSDictionary *)fullReadWriteAccessDictionary
{
    return @{@"write" : @(YES) , @"read" : @(YES)};
}


- (BOOL)readAccess
{
    return [self[@"read"] boolValue];
}


- (void)setReadAccess:(BOOL)readAccess
{
    self[@"read"] = @(readAccess);
}


- (BOOL)writeAccess
{
    return [self[@"write"] boolValue];
}


- (void)setWriteAccess:(BOOL)writeAccess
{
    self[@"write"] = @(writeAccess);
}

@end


@interface StringrACL ()

@property (nonatomic) BOOL publicReadAccess;
@property (nonatomic) BOOL publicWriteAccess;

@property (strong, nonatomic) NSMutableDictionary *permissionsDictionary;

@property (strong, nonatomic) PFACL *PFACL;

@end

@implementation StringrACL

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _publicReadAccess = NO;
        _publicWriteAccess = NO;
        _permissionsDictionary = [NSMutableDictionary new];
        
        _PFACL = [PFACL ACL];
    }
    
    return self;
}


+ (StringrACL *)ACL
{
    StringrACL *ACL = [StringrACL new];
    
    return ACL;
}


+ (StringrACL *)ACLWithUser:(StringrUser *)user
{
    StringrACL *ACL = [StringrACL ACL];
    ACL.PFACL = [PFACL ACLWithUser:user.PFUser];
    
    ACL.permissionsDictionary[user.objectID] = @{user.objectID : [NSMutableDictionary fullReadWriteAccessDictionary]};
    
    return ACL;
}


+ (void)setDefaultACL:(StringrACL *)ACL withAccessForCurrentUser:(StringrUser *)user
{
    
}


#pragma mark - Set/Get Read Access

- (void)setPublicReadAccess:(BOOL)allowed
{
    self.publicReadAccess = allowed;
    [self.PFACL setPublicReadAccess:allowed];
}


- (BOOL)getPublicReadAccess
{
    return self.publicReadAccess;
}


- (void)setReadAccess:(BOOL)allowed forUser:(StringrUser *)user
{
    NSMutableDictionary *readAccessDictionary = self.permissionsDictionary[user.objectID];
    
    if (!readAccessDictionary)
    {
        readAccessDictionary = [NSMutableDictionary new];
    }
    
    readAccessDictionary.readAccess = allowed;
    
    self.permissionsDictionary[user.objectID] = @{user.objectID : readAccessDictionary};
    
    [self.PFACL setReadAccess:allowed forUser:user.PFUser];
}


- (BOOL)getReadAccessForUser:(StringrUser *)user
{
    NSMutableDictionary *readAccessDictionary = self.permissionsDictionary[user.objectID];
    
    if (readAccessDictionary) {
        return readAccessDictionary.readAccess;
    }
    
    return NO;
}


#pragma mark - Set/Get WriteAccess

- (void)setPublicWriteAccess:(BOOL)allowed
{
    self.publicWriteAccess = allowed;
}


- (BOOL)getPublicWriteAccess
{
    return self.publicWriteAccess;
}


- (void)setWriteAccess:(BOOL)allowed forUser:(StringrUser *)user
{
    NSMutableDictionary *writeAccessDictionary = self.permissionsDictionary[user.objectID];
    
    if (writeAccessDictionary)
    {
        writeAccessDictionary = [NSMutableDictionary new];
    }
    
    writeAccessDictionary.writeAccess = allowed;
    
    self.permissionsDictionary[user.objectID] = @{user.objectID : writeAccessDictionary};
}


- (BOOL)getWriteAccessForUser:(StringrUser *)user
{
    NSMutableDictionary *writeAccessDictionary = self.permissionsDictionary[user.objectID];
    
    if (writeAccessDictionary) {
        return writeAccessDictionary.writeAccess;
    }
    
    return NO;
}


@end
