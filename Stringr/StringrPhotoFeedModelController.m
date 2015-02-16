//
//  StringrPhotoFeedModelController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/9/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoFeedModelController.h"
#import "StringrNetworkTask+Strings.h"

@interface StringrPhotoFeedModelController ()

@end

@implementation StringrPhotoFeedModelController

- (void)setString:(StringrString *)string
{
    _string = string;
    
    [self loadStringPhotoData];
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    [self.delegate photoDataDidUpdate];
}


- (void)setDataType:(StringrNetworkPhotoTaskType)dataType
{
    _dataType = dataType;
    
    [self startPhotoNetworkTask];
}


- (void)startPhotoNetworkTask
{
    [StringrNetworkTask photosForDataType:self.dataType user:self.user completion:^(NSArray *photos, NSError *error) {
        self.photos = photos;
        self.string.photos = [photos mutableCopy];
    }];
}


- (void)loadStringPhotoData
{
    [StringrNetworkTask photosForString:self.string.parseString completion:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photos = photos;
            self.string.photos = [photos mutableCopy];
        }
    }];
}

@end
