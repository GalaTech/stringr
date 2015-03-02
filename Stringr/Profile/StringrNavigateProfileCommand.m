//
//  StringrNavigateProfileCommand.m
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateProfileCommand.h"
#import "StringrUserStringFeedViewController.h"
#import "StringrPhotoFeedViewController.h"
#import "StringrProfileStringFeedViewController.h"
#import "StringrProfilePhotoFeedViewController.h"

#import "StringrNetworkTask.h"

@implementation StringrNavigateProfileCommand

- (UIViewController *)commandViewController
{
    if (self.commandType == ProfileCommandUserStrings) {
        StringrProfileStringFeedViewController *userStringsFeedVC = [StringrProfileStringFeedViewController stringFeedWithDataType:StringrUserStringsNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            userStringsFeedVC.delegate = self.delegate;
        }
        
        return userStringsFeedVC;
    }
    else if (self.commandType == ProfileCommandLikedStrings) {
        StringrProfileStringFeedViewController *userLikedStringsFeedVC = [StringrProfileStringFeedViewController stringFeedWithDataType:StringrLikedStringsNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            userLikedStringsFeedVC.delegate = self.delegate;
        }
        
        return userLikedStringsFeedVC;
    }
    else if (self.commandType == ProfileCommandLikedPhotos) {
        StringrProfilePhotoFeedViewController *photoFeedVC = [StringrProfilePhotoFeedViewController photoFeedWithDataType:StringrUserPhotosNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            photoFeedVC.delegate = self.delegate;
        }
        
        return photoFeedVC;
    }
    else if (self.commandType == ProfileCommandPublicPhotos) {
        StringrProfilePhotoFeedViewController *photoFeedVC = [StringrProfilePhotoFeedViewController photoFeedWithDataType:StringrUserPublicPhotosNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            photoFeedVC.delegate = self.delegate;
        }
        
        return photoFeedVC;
    }
    
    return [UIViewController new];
}


- (void)dealloc
{
    NSLog(@"Dealloc'd StringrNavigateProfileCommand");
}

@end
