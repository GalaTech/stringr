//
//  StringrPhotoCollectionViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrViewController.h"
#import "StringrPhotoFeedModelController.h"

#import "StringrNetworkTask+Photos.h"

@protocol StringrContainerScrollViewDelegate;

@interface StringrPhotoFeedViewController : UIViewController <StringrViewController>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) StringrPhotoFeedModelController *modelController;

+ (instancetype)photoFeedWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user;
+ (instancetype)photoFeedFromString:(StringrString *)string;
+ (instancetype)photoFeedFromPhotos:(NSArray *)photos;

@end
