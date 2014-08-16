//
//  StringrFlagContentHelper.h
//  Stringr
//
//  Created by Jonathan Howard on 8/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrFlagContentHelper : NSObject

+ (void)flagContent:(PFObject *)content withFlaggingUser:(PFUser *)user;
+ (void)flagContent:(PFObject *)content withFlaggingUser:(PFUser *)user completionHandler:(void (^)(BOOL success, NSError *))completionHandler;

@end
