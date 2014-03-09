//
//  StringrStringDetailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTableViewController.h"
#import "QMBParallaxScrollViewController.h"

@interface StringrStringDetailTableViewController : StringrDetailTableViewController

@property (strong, nonatomic) NSString *stringTitle;
@property (weak, nonatomic) UITextField *stringTitleTextField;
@property (strong, nonatomic) PFObject *stringDetailsToLoad;

@end
