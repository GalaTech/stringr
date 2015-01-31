//
//  StringrStringTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrTableViewController.h"
#import "StringrNetworkTask+Strings.h"

@interface StringrStringFeedViewController : UITableViewController <StringrViewController>

@property (nonatomic) StringrNetworkStringTaskType dataType;
@property (strong, nonatomic) NSArray *strings;

- (instancetype)initWithDataType:(StringrNetworkStringTaskType)taskType;
- (instancetype)initWithStrings:(NSArray *)strings;

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType;
+ (instancetype)stringFeedWithStrings:(NSArray *)strings;

@end
