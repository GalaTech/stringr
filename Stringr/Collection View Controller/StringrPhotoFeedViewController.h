//
//  StringrPhotoCollectionViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrViewController.h"
#import "StringrContainerScrollViewDelegate.h"

#import "StringrNetworkTask+Photos.h"

@protocol StringrContainerScrollViewDelegate;

@interface StringrPhotoFeedViewController : UIViewController <StringrViewController>

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

+ (StringrPhotoFeedViewController *)photoFeedWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user;
+ (StringrPhotoFeedViewController *)photoFeedFromString:(StringrString *)string;
+ (StringrPhotoFeedViewController *)photoFeedFromPhotos:(NSArray *)photos;

@end
