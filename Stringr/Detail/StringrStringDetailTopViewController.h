//
//  StringrStringTopEditViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTopViewController.h"


@interface StringrStringDetailTopViewController : StringrDetailTopViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) PFObject *stringToLoad;
@property (strong, nonatomic) NSMutableArray *stringPhotos;

- (void)addImageToString:(UIImage *)image withBlock:(void (^)(BOOL succeeded, PFObject *photo, NSError *error))completionBlock;
- (void)queryPhotosFromString;

@end
