//
//  StringrNetworkRequests.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask.h"

#import "StringrNetworkTask+Strings.h"
#import "StringrNetworkTask+Profile.h"

@implementation StringrNetworkTask

+ (StringrObjectType)objectType:(PFObject *)object
{
    if ([object.parseClassName isEqualToString:kStringrUserClassKey]) {
        return StringrUserType;
    }
    else if ([object.parseClassName isEqualToString:kStringrStringClassKey]) {
        return StringrStringType;
    }
    else if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
        return StringrPhotoType;
    }
    else if ([object.parseClassName isEqualToString:kStringrActivityClassKey]) {
        NSString *activityType = [object objectForKey:kStringrActivityTypeKey];
        
        if ([activityType isEqualToString:kStringrActivityTypeLike]) {
            return StringrLikeType;
        }
        else if ([activityType isEqualToString:kStringrActivityTypeComment]) {
            return StringrCommentType;
        }
        else if ([activityType isEqualToString:kStringrActivityTypeFollow]) {
            return StringrFollowType;
        }
        else if ([activityType isEqualToString:kStringrActivityTypeMention]) {
            return StringrMentionType;
        }
        else if ([activityType isEqualToString:kStringrActivityTypeAddedPhotoToPublicString])
        {
            return StringrContributedType;
        }
    }
    
    return StringrNoType;
}


+ (void)stringsForDataType:(StringrNetworkStringTaskType)dataType user:(PFUser *)user completion:(StringrStringsBlock)completion
{
    if (completion) {
        switch (dataType) {
            case StringrMyStringrNetworkTask:
                [StringrNetworkTask stringsForUser:[PFUser currentUser] completion:completion];
                break;
            case StringrFollowingNetworkTask:
                [StringrNetworkTask homeFeedForUser:user completion:completion];
                break;
            default:
                break;
        }
    }
}


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
