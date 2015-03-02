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

#import "STGRStringFeedModelController.h"

@interface StringrStringFeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, StringrViewController>

@property (strong, nonatomic) STGRStringFeedModelController *modelController;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) StringrNetworkStringTaskType dataType;

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType;
+ (instancetype)stringFeedWithCategory:(StringrExploreCategory *)category;
+ (instancetype)stringFeedWithStrings:(NSArray *)strings;

@end
