//
//  StringrNetworkTask+Photos.h
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

typedef enum {
    StringrUserPhotosNetworkTask = 0,
    StringrUserPublicPhotosNetworkTask
} StringrNetworkPhotoTaskType;

typedef void (^StringrPhotosBlock)(NSArray *photos, NSError *error);

@interface StringrNetworkTask (Photos)

+ (void)photosForDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user completion:(StringrPhotosBlock)completion;

@end
