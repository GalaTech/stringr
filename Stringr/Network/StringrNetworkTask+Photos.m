//
//  StringrNetworkTask+Photos.m
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Profile.h"

@implementation StringrNetworkTask (Photos)

+ (void)photosForDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user completion:(StringrPhotosBlock)completion
{
    if (completion) {
        switch (dataType) {
            case StringrUserPhotosNetworkTask:
                [StringrNetworkTask likedPhotosForUser:user completion:completion];
                break;
            case StringrUserPublicPhotosNetworkTask:
                [StringrNetworkTask publicPhotosForUser:user completion:completion];
                break;
            default:
                break;
        }
    }
}

@end
