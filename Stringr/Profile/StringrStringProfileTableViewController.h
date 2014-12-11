//
//  StringrStringProfileTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"

@protocol StringrContainerScrollViewDelegate;

@interface StringrStringProfileTableViewController : StringrStringTableViewController

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

@end
