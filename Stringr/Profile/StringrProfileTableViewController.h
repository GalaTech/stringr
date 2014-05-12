//
//  StringrProfileTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "QMBParallaxScrollViewController.h"

@protocol StringrProfileTableViewControllerDelegate;

@interface StringrProfileTableViewController : StringrStringTableViewController<QMBParallaxScrollViewHolder>

@property (weak, nonatomic) id<StringrProfileTableViewControllerDelegate> delegate;

@end


@protocol StringrProfileTableViewControllerDelegate <NSObject>

- (void)bottomTableView:(UITableView *)tableView didFinishLoadingWithData:(NSArray *)data;

@end