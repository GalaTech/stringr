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

#import "StringrNetworkTask.h"

@protocol StringrContainerScrollViewDelegate;

@interface StringrPhotoCollectionViewController : UIViewController <StringrViewController>

- (instancetype)initWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user;

@property (strong, nonatomic) NSArray *photos;

@property (weak, nonatomic) id<StringrContainerScrollViewDelegate> delegate;

@property (strong, nonatomic) PFUser *user;

@end
