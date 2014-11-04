//
//  StringrStringTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrTableViewController.h"
#import "REFrostedViewController.h"
#import "StringrStringHeaderView.h"

@interface StringrStringTableViewController : StringrTableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *stringPhotos;

@end
