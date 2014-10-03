//
//  StringrNetworkRequests.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkRequests.h"

@implementation StringrNetworkRequests

+ (void)addObject:(StringrObject *)object
{
//    PFObject *objectTest = [PFObject objectWithClassName:[StringrObject parseClassName]];

    
//    [objectTest saveInBackground];
}

+ (void)getObjectWithName:(NSString *)name completionBlock:(void (^)(StringrObject *object, BOOL success))completionBlock
{
//    PFQuery *nameQuery = [PFQuery queryWithClassName:@"Object"];
//    [nameQuery whereKey:@"name" equalTo:name];
//    [nameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            if (completionBlock) {
//                StringrObject *object = [StringrObject new];
//
//                completionBlock(object, YES);
//            }
//        }
//        else {
//            if (completionBlock) {
//                completionBlock(nil, NO);
//            }
//        }
//    }];
}

@end
