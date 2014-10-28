//
//  StringrTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 3/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrAppDelegate.h"
#import "StringrNoContentView.h"

@interface StringrTableViewController : PFQueryTableViewController <StringrNoContentViewDelegate, UIActionSheetDelegate>

+ (instancetype)viewController;

@property (strong, nonatomic, readonly) UIStoryboard *mainStoryboard;

- (void)setQueryForTable:(PFQuery *)queryForTable;
- (PFQuery *)getQueryForTable;
- (void)addNewString;


@end
