//
//  StringrWriteCommentViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/3/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrWriteCommentViewController;

@protocol StringrWriteCommentDelegate <NSObject>

/**
 * Alerts the delegate that the user did post a comment.
 * @param commentView The comment view that posted the comment object
 * @param comment The comment that was posted by the user
 */
- (void)commentViewController:(StringrWriteCommentViewController *)commentView didPostComment:(PFObject *)comment;

/**
 * Alerts the delegate that the user cancelled the comment view
 * @param commentView The modally presented comment view.
 */
- (void)commentViewControllerDidCancel:(StringrWriteCommentViewController *)commentView;

@end

//________________________________________________________________________________________________________________

@interface StringrWriteCommentViewController : UIViewController

@property (strong, nonatomic) PFObject *objectToCommentOn; // String or photo object
@property (strong, nonatomic) NSArray *commentors;
@property (weak, nonatomic) id<StringrWriteCommentDelegate> delegate;

@end



