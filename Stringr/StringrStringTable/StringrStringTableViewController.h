//
//  StringrStringTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrTableViewController.h"

@interface StringrStringTableViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *stringPhotos;

@end
