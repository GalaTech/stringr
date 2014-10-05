//
//  StringrRootViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "REFrostedViewController.h"
#import "StringrLoginViewController.h"

@interface StringrAppController : REFrostedViewController <StringrLoginViewControllerDelegate>

- (void)launchSequence:(NSDictionary *)launchOptions;

- (BOOL)isParseReachable;

@end
