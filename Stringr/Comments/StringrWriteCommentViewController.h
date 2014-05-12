//
//  StringrWriteCommentViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/3/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrWriteCommentDelegate;

@interface StringrWriteCommentViewController : UIViewController

@property (weak, nonatomic) id<StringrWriteCommentDelegate> delegate;
@property (strong, nonatomic) PFObject *objectToCommentOn;
@property (strong, nonatomic) NSArray *commentors;

@end

@protocol StringrWriteCommentDelegate <NSObject>

- (void)reloadCommentTableView;

@end

