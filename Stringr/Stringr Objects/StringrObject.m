//
//  StringrObject.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"

@interface StringrObject ()

@property (strong, nonatomic, readwrite) NSDate *updatedAt;
@property (strong, nonatomic, readwrite) NSDate *createdAt;
@property (copy, nonatomic, readwrite) NSString *parseClassName;

@end

@implementation StringrObject

+ (NSString *)className
{
    return @"Object";
}


#pragma mark - Bridging

+ (PFObject *)bridgeStringrObjectToPFObject:(StringrObject *)object
{
    PFObject *bridgedPFObject = [PFObject objectWithClassName:[self className]];
    bridgedPFObject.objectId = object.objectID;
    
    // bridge to ACL
    
    return bridgedPFObject;
}


+ (StringrObject *)bridgePFObjectToStringrObject:(PFObject *)object
{
    StringrObject *bridgedStringrObject = [StringrObject new];
    bridgedStringrObject.parseClassName = object.parseClassName;
    bridgedStringrObject.objectID = object.objectId;

    // bridge to ACL
    
    bridgedStringrObject.updatedAt = object.updatedAt;
    bridgedStringrObject.createdAt = object.createdAt;
    
    return bridgedStringrObject;
}


#pragma mark - Setting and Removing Objects

- (id)objectForKey:(NSString *)key
{
    return nil;
}


- (void)setStringrObject:(StringrObject *)object forKey:(NSString *)key
{   
    
    
}


- (void)removeObjectForKey:(NSString *)key
{
    
}


#pragma mark - Save Single

- (BOOL)save
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    return [parseObject save];
}


- (void)saveInBackground
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject saveInBackground];
}


- (void)saveInBackgroundWithBlock:(StringrBooleanResultBlock)block
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (block)
        {
            block(succeeded, error);
        }
    }];
}


- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject saveInBackgroundWithTarget:target selector:selector];
}


- (void)saveEventually
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject saveEventually];
}


- (void)saveEventuallyWithBlock:(StringrBooleanResultBlock)block
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (block)
        {
            block(succeeded, error);
        }
    }];
}


#pragma mark - Save All

+ (BOOL)saveAll:(NSArray *)objects
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    return [PFObject saveAll:PFObjectArray];
}


+ (BOOL)saveAll:(NSArray *)objects error:(NSError **)error
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    return [PFObject saveAll:PFObjectArray error:error];
}


+ (void)saveAllInBackground:(NSArray *)objects
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    [PFObject saveAllInBackground:PFObjectArray];
}


+ (void)saveAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    [PFObject saveAllInBackground:PFObjectArray block:^(BOOL succeeded, NSError *error) {
        if (block)
        {
            block(succeeded, error);
        }
    }];
}


#pragma mark - Delete Single

- (BOOL)delete
{
    return [[self.class bridgeStringrObjectToPFObject:self] delete];
}


- (BOOL)delete:(NSError **)error
{
    return [[self.class bridgeStringrObjectToPFObject:self] delete:error];
}


- (void)deleteInBackground
{
    [[self.class bridgeStringrObjectToPFObject:self] deleteInBackground];
}


- (void)deleteInBackgroundWithBlock:(StringrBooleanResultBlock)block
{
    [[self.class bridgeStringrObjectToPFObject:self] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (block)
        {
            block(succeeded, error);
        }
    }];
}


- (void)deleteEventually
{
    [[self.class bridgeStringrObjectToPFObject:self] deleteEventually];
}


#pragma mark - Delete All

+ (BOOL)deleteAll:(NSArray *)objects
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    return [PFObject deleteAll:PFObjectArray];
}


+ (BOOL)deleteAll:(NSArray *)objects error:(NSError **)error
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    return [PFObject deleteAll:PFObjectArray error:error];
}


+ (void)deleteAllInBackground:(NSArray *)objects
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    [PFObject deleteAllInBackground:PFObjectArray];
}


+ (void)deleteAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block
{
    NSMutableArray *PFObjectArray = [NSMutableArray new];
    
    for (StringrObject *object in objects) {
        PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:object];
        
        [PFObjectArray addObject:parseObject];
    }
    
    [PFObject deleteAllInBackground:PFObjectArray block:^(BOOL succeeded, NSError *error) {
        if (block)
        {
            block(succeeded, error);
        }
    }];
}



#pragma mark - Refresh

- (BOOL)isDataAvailable
{
    return [[self.class bridgeStringrObjectToPFObject:self] isDataAvailable];
}


- (void)refresh
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject refresh];
    
    [self.class bridgePFObjectToStringrObject:parseObject];
}


- (void)refresh:(NSError **)error
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject refresh:error];
    
    [self.class bridgePFObjectToStringrObject:parseObject];
}


- (void)refreshInBackgroundWithBlock:(StringrResultBlock)block
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.class bridgePFObjectToStringrObject:object];
        
        if (block)
        {
            block(self, error);
        }
    }];;
}


#pragma mark - Fetch Single

- (void)fetch
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject fetch];
}


- (void)fetch:(NSError **)error
{
    
}


- (void)fetchInBackgroundWithBlock:(StringrResultBlock)block
{
    
}


- (StringrObject *)fetchIfNeeded
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    parseObject = [parseObject fetchIfNeeded];
    
    return [self.class bridgePFObjectToStringrObject:parseObject];
}


- (StringrObject *)fetchIfNeeded:(NSError **)error
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    parseObject = [parseObject fetchIfNeeded:error];
    
    return [self.class bridgePFObjectToStringrObject:parseObject];
}


- (void)fetchIfNeededinBackgroundWithBlock:(StringrResultBlock)block
{
    PFObject *parseObject = [self.class bridgeStringrObjectToPFObject:self];
    
    [parseObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.class bridgePFObjectToStringrObject:object];
        
        if (block)
        {
            block(self, error);
        }
    }];
}


#pragma mark - Fetch All

+ (void)fetchAll:(NSArray *)objects
{

}


+ (void)fetchAll:(NSArray *)objects error:(NSError **)error
{
    
}


+ (void)fetchAllInBackground:(NSArray *)objects block:(StringrArrayResultBlock)block
{
    
}


+ (void)fetchAllIfNeeded:(NSArray *)objects
{
    
}


+ (void)fetchAllIfNeeded:(NSArray *)objects error:(NSError **)error
{
    
}


+ (void)fetchAllIfNeededInBackground:(NSArray *)objects block:(StringrArrayResultBlock)block
{
    
}


@end
