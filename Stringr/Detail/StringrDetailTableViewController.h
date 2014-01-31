//
//  StringrDetailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"

@interface StringrDetailTableViewController : UITableViewController<QMBParallaxScrollViewHolder>

@property (strong, nonatomic) NSArray *sectionHeaderTitles;

@end
