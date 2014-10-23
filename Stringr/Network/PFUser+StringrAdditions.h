//
//  PFUser+StringrAdditions.h
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFUser (StringrAdditions)

- (void)fetchUserIfNeededInBackgroundWithBlock:( void (^)(PFUser *user, NSError *error))block;

@end
