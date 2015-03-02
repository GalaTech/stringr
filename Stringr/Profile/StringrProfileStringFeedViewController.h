//
//  StringrProfileStringFeedViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/18/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrUserStringFeedViewController.h"

#import "StringrContainerScrollViewDelegate.h"

@interface StringrProfileStringFeedViewController : StringrUserStringFeedViewController

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

@end
