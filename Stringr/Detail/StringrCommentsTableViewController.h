//
//  StringrStringCommentsViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrTableViewController.h"

@protocol StringrCommentsTableViewDelegate;
@interface StringrCommentsTableViewController : StringrTableViewController

/**
 * The String or Photo PFObject that is being commented on. The comments table will be populated with
 * all comments that pertain to this object.
 */
@property (strong, nonatomic) PFObject *objectForCommentThread;

/**
 * Determines whether or not the comments should be editable to the current user.
 * The current purpose for this is to allow the uploader of a String or Photo have 
 * full access to delete comments that they see unfit for their String/Photo.
 */
@property (nonatomic) BOOL commentsEditable;

/**
 * The section from the caller that this comments table view is being instantiated from.
 * This property is not necessary if you're not calling it from a table view.
 */
@property (nonatomic) NSUInteger section;

@property (weak, nonatomic) id<StringrCommentsTableViewDelegate> delegate;

@end

@protocol StringrCommentsTableViewDelegate <NSObject>

/**
 * Alerts the delegate that the comments table has either increased or decreased the number of comments
 * @param commentsTableView The table view of comments
 * @param section The section of the calling table view that this comments table view was called from.
 */
- (void)commentsTableView:(StringrCommentsTableViewController *)commentsTableView didChangeCommentCountInSection:(NSUInteger)section;

@end
