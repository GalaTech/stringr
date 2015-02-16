//
//  StringrPhotoFeedModelController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/9/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringrNetworkTask+Photos.h"

@protocol StringrPhotoFeedModelControllerDelegate;

@interface StringrPhotoFeedModelController : NSObject

@property (strong, nonatomic) StringrString *string;
@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) PFUser *user;
@property (nonatomic) StringrNetworkPhotoTaskType dataType;

@property (weak, nonatomic) id<StringrPhotoFeedModelControllerDelegate> delegate;

@end

@protocol StringrPhotoFeedModelControllerDelegate <NSObject>

- (void)photoDataDidUpdate;

@end
