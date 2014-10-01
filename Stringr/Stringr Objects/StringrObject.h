//
//  StringrObject.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

@class StringrACL;

typedef void (^StringrBooleanResultBlock)(BOOL succeeded, NSError *error);

@interface StringrObject : NSObject

+ (NSString *)parseClassName;


@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) StringrACL *ACL;


- (id)objectForKey:(NSString *)key;
- (void)setStringrObject:(StringrObject *)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;


- (void)incrementKey:(NSString *)key;
- (void)incrementKey:(NSString *)key byAmount:(NSNumber *)amount;


- (PFObject *)bridgeToPFObject;
- (StringrObject *)bridgePFObjectToStringrObject:(PFObject *)object;


- (BOOL)save;
- (void)saveInBackground;
- (void)saveInBackgroundWithBlock:(StringrBooleanResultBlock)block;
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)saveEventually;
- (void)saveEventuallyWithBlock:(StringrBooleanResultBlock)block;


+ (BOOL)saveAll:(NSArray *)objects;
+ (BOOL)saveAll:(NSArray *)objects error:(NSError *)error;
+ (void)saveAllInBackground:(NSArray *)objects;
+ (void)saveAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block;


+ (BOOL)deleteAll:(NSArray *)objects;
+ (BOOL)deleteAll:(NSArray *)objects error:(NSError *)error;
+ (void)deleteAllInBackground:(NSArray *)objects;
+ (void)deleteAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block;


/*
 
 Properties
 parseClassName
 objectID
 updatedAt
 createdAt
 ACL
 
 
 General
 
 - objectForKey:
 - setObject:forKey:
 - removeObjectForKey:
 
 - incrementKey:
 - ncrementKey:byAmount
 
 - bridgeToPFObject
 - bridgeToStringrObject
 
 
 Saving single objects
 - save
 - saveInBackground
 - saveInBackgroundWithBlock:
 - saveInBackgroundWithTarget:selector:
 - saveEventually
 
 
 Saving many objects
 + saveAll:
 + SaveAll:error:
 + saveAllInBackground:
 + saveAllInBackground:block:
 
 
 
 Deleting many objects
 + deleteAll:
 + deleteAll:error:
 + deleteAllInBackground:
 + deleteAllInBackground:block:
 
 
 
 Getting an object from Parse
 
 
 * – isDataAvailable
 * – refresh
 * – refresh:
 * – refreshInBackgroundWithBlock:
 * – fetch
 * – fetch:
 * – fetchIfNeeded
 * – fetchIfNeeded:
 * – fetchInBackgroundWithBlock:
 * – fetchInBackgroundWithTarget:selector:
 * – fetchIfNeededInBackgroundWithBlock:
 
 
 Getting many objects from Parse
 
 
 
 * + fetchAll:
 * + fetchAll:error:
 * + fetchAllIfNeeded:
 * + fetchAllIfNeeded:error:
 * + fetchAllInBackground:block:
 * + fetchAllIfNeededInBackground:block:
 
 
 Removing an object from Parse
 
 
 * – delete
 * – delete:
 * – deleteInBackground
 * – deleteInBackgroundWithBlock:
 * – deleteEventually
*/


@end
