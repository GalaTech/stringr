//
//  StringrNetworkTask+Profile.h
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

/// @param items An array of a user's Strings, Photos, etc.
typedef void (^StringrUserItemsBlock)(NSArray *items, NSError *error);

@interface StringrNetworkTask (Profile)

+ (void)stringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion;
+ (void)likedStringsForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion;
+ (void)likedPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion;
+ (void)publicPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion;

@end
