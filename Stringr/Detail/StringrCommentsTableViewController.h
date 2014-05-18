//
//  StringrStringCommentsViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrTableViewController.h"

@interface StringrStringCommentsViewController : StringrTableViewController

@property (nonatomic) BOOL commentsEditable;
@property (strong, nonatomic) PFObject *objectForCommentThread;

@end
