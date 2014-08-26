//
//  StringrPhotoDetailEditTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTableViewController.h"

@protocol StringrPhotoDetailEditTableViewControllerDelegate;

@interface StringrPhotoDetailEditTableViewController : StringrPhotoDetailTableViewController

@property (weak, nonatomic) id<StringrPhotoDetailEditTableViewControllerDelegate> delegate;

- (BOOL)photoIsPreparedToSave;

@end

@protocol StringrPhotoDetailEditTableViewControllerDelegate <NSObject>

@optional
- (void)deletePhotoFromString:(PFObject *)photo;
- (void)deletePhotoFromPublicString:(PFObject *)photo;

@end