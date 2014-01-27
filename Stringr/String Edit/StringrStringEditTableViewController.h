//
//  StringrStringDetailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"

@interface StringrStringEditTableViewController : UITableViewController<QMBParallaxScrollViewHolder>

@property (strong, nonatomic) NSString *stringTitle;
@property (weak, nonatomic) UITextField *stringTitleTextField;

@end
