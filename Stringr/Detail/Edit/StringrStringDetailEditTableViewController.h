//
//  StringrStringDetailEditTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTableViewController.h"

@protocol StringrStringDetailEditTableViewControllerDelegate;

@interface StringrStringDetailEditTableViewController : StringrStringDetailTableViewController

@property (weak, nonatomic) id<StringrStringDetailEditTableViewControllerDelegate> delegate;

@end


@protocol StringrStringDetailEditTableViewControllerDelegate <NSObject>

@optional
- (void)setTitleForString:(NSString *)title;
- (void)setDescriptionForString:(NSString *)description;
- (void)setWriteAccessForString:(BOOL)canWrite;
- (void)deleteString;

- (void)changeTopHeightOfParallax;

@end
