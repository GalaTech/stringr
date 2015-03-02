//
//  StringrUserStringFeedViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/31/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrStringFeedViewController.h"

@interface StringrUserStringFeedViewController : StringrStringFeedViewController

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType user:(PFUser *)user;

@end
