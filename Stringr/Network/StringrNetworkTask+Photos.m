//
//  StringrNetworkTask+Photos.m
//  Stringr
//
//  Created by Jonathan Howard on 12/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Profile.h"
#import "StringrPhoto.h"

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


+ (void)photosForString:(PFObject *)string completion:(StringrPhotosBlock)completion
{
    PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
    [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:string];
    [stringPhotoQuery orderByAscending:@"photoOrder"];
    [stringPhotoQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
        if (completion) {
            completion([StringrPhoto photosFromArray:photos], error);
        }
    }];
}


#pragma mark - Profile

+ (void)likedPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *likePhotosActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likePhotosActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likePhotosActivityQuery whereKey:kStringrActivityFromUserKey equalTo:user];
    [likePhotosActivityQuery whereKeyExists:kStringrActivityPhotoKey];
    [likePhotosActivityQuery includeKey:kStringrActivityPhotoKey];
    [likePhotosActivityQuery orderByDescending:@"createdAt"];
    [likePhotosActivityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [likePhotosActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            NSArray *likedPhotosArray = [self likedPhotosFromActivityArray:objects];
            completion(likedPhotosArray, error);
        }
    }];
}


+ (void)publicPhotosForUser:(PFUser *)user completion:(StringrUserItemsBlock)completion
{
    PFQuery *publicPhotosQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [publicPhotosQuery whereKey:kStringrActivityFromUserKey equalTo:user];
    [publicPhotosQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeAddedPhotoToPublicString];
    [publicPhotosQuery whereKeyExists:kStringrActivityPhotoKey];
    [publicPhotosQuery includeKey:kStringrActivityPhotoKey];
    [publicPhotosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            NSArray *likedPhotosArray = [self likedPhotosFromActivityArray:objects];
            completion(likedPhotosArray, error);
        }
    }];
}


+ (NSArray *)likedPhotosFromActivityArray:(NSArray *)actitvities
{
    NSMutableArray *photos = [NSMutableArray new];
    
    for (PFObject *activityObject in actitvities) {
        PFObject *photo = [activityObject objectForKey:kStringrActivityPhotoKey];
        if (photo) {
            [photos addObject:photo];
        }
        
        // fetches the photos associated String object for future photo owner functionality
        PFObject *string = [[activityObject objectForKey:kStringrActivityPhotoKey] objectForKey:kStringrPhotoStringKey];
        if (string) {
            [string fetchIfNeededInBackgroundWithBlock:nil];
        }
    }
    
    return [StringrPhoto photosFromArray:photos];
}

@end
