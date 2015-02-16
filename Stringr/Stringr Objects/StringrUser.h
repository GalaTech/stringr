//
//  StringrUser.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringrObject.h"

@interface StringrUser : NSObject <StringrObject>

@property (strong, nonatomic, readonly) PFUser *parseUser;

@end
