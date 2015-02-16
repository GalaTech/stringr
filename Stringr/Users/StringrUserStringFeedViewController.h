//
//  StringrUserStringFeedViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/31/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrStringFeedViewController.h"

#import "StringrContainerScrollViewDelegate.h"

@interface StringrUserStringFeedViewController : StringrStringFeedViewController<StringrContainerScrollViewDelegate>

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType user:(PFUser *)user;

@end
