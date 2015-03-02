//
//  StringrProfilePhotoFeedViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/19/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoFeedViewController.h"

#import "StringrContainerScrollViewDelegate.h"

@interface StringrProfilePhotoFeedViewController : StringrPhotoFeedViewController

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

@end
