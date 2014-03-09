//
//  StringrStringDetailTopEditViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTopViewController.h"
#import "StringrStringDetailTopViewController.h"
#import "StringrStringDetailEditTableViewController.h"

@interface StringrStringDetailEditTopViewController : StringrStringDetailTopViewController <StringrStringDetailEditViewControllerDelegate>

@property (strong, nonatomic) UIImage *userSelectedPhoto; // from UIImagePickerView

@end
