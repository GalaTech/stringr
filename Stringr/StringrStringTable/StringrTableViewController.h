//
//  StringrTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 3/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrTableViewController : PFQueryTableViewController

- (void)setQueryForTable:(PFQuery *)queryForTable;
- (PFQuery *)getQueryForTable;

@end
