//
//  PFUser+StringrAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "PFUser+StringrAdditions.h"

@implementation PFUser (StringrAdditions)

- (void)fetchUserIfNeededInBackgroundWithBlock:( void (^)(PFUser *user, NSError *error))block
{
    [self fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (block) {
            block((PFUser *)object, error);
        }
    }];
}

@end
