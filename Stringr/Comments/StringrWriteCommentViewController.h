//
//  StringrWriteCommentViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/3/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrWriteCommentDelegate <NSObject>

- (void)pushSavedComment:(NSDictionary *)comment;

@end

@interface StringrWriteCommentViewController : UIViewController

@property (strong, nonatomic) id<StringrWriteCommentDelegate> delegate;

@end
