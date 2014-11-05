//
//  StringrObject.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

@class StringrACL;
@class StringrObject;

typedef void (^StringrBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^StringrResultBlock)(StringrObject *object, NSError *error);
typedef void (^StringrArrayResultBlock)(NSArray *objects, NSError *error);

@interface StringrObject : NSObject

@property (copy, nonatomic, readonly) NSString *parseClassName;
@property (copy, nonatomic) NSString *objectID;
@property (strong, nonatomic, readonly) NSDate *updatedAt;
@property (strong, nonatomic, readonly) NSDate *createdAt;
@property (strong, nonatomic) StringrACL *ACL;


/*

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *lastName;

// Setting/Removing

- (id)objectForKey:(NSString *)key;
- (void)setStringrObject:(StringrObject *)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;


// Increment/Decrement

//- (void)incrementKey:(NSString *)key;
//- (void)incrementKey:(NSString *)key byAmount:(NSNumber *)amount;


// Conversion

+ (PFObject *)bridgeStringrObjectToPFObject:(StringrObject *)object;
+ (StringrObject *)bridgePFObjectToStringrObject:(PFObject *)object;


// Saving

- (BOOL)save;
- (void)saveInBackground;
- (void)saveInBackgroundWithBlock:(StringrBooleanResultBlock)block;
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)saveEventually;
- (void)saveEventuallyWithBlock:(StringrBooleanResultBlock)block;


+ (BOOL)saveAll:(NSArray *)objects;
+ (BOOL)saveAll:(NSArray *)objects error:(NSError **)error;
+ (void)saveAllInBackground:(NSArray *)objects;
+ (void)saveAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block;


// Deletion

- (BOOL)delete;
- (BOOL)delete:(NSError **)error;
- (void)deleteInBackground;
- (void)deleteInBackgroundWithBlock:(StringrBooleanResultBlock)block;
- (void)deleteEventually;

+ (BOOL)deleteAll:(NSArray *)objects;
+ (BOOL)deleteAll:(NSArray *)objects error:(NSError **)error;
+ (void)deleteAllInBackground:(NSArray *)objects;
+ (void)deleteAllInBackground:(NSArray *)objects block:(StringrBooleanResultBlock)block;


// Retrieving

- (BOOL)isDataAvailable;
- (void)refresh;
- (void)refresh:(NSError **)error;
- (void)refreshInBackgroundWithBlock:(StringrResultBlock)block;

- (void)fetch;
- (void)fetch:(NSError **)error;
- (void)fetchInBackgroundWithBlock:(StringrResultBlock)block;
- (StringrObject *)fetchIfNeeded;
- (StringrObject *)fetchIfNeeded:(NSError **)error;
- (void)fetchIfNeededinBackgroundWithBlock:(StringrResultBlock)block;

+ (void)fetchAll:(NSArray *)objects;
+ (void)fetchAll:(NSArray *)objects error:(NSError **)error;
+ (void)fetchAllInBackground:(NSArray *)objects block:(StringrArrayResultBlock)block;
+ (void)fetchAllIfNeeded:(NSArray *)objects;
+ (void)fetchAllIfNeeded:(NSArray *)objects error:(NSError **)error;
+ (void)fetchAllIfNeededInBackground:(NSArray *)objects block:(StringrArrayResultBlock)block;
*/

@end
