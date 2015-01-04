//
//  StringrNavigateProfileCommand.m
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateProfileCommand.h"
#import "StringrFollowingTableViewController.h"
#import "StringrProfileTableViewController.h"
#import "StringrPhotoCollectionViewController.h"
#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"

#import "StringrNetworkTask.h"

@implementation StringrNavigateProfileCommand

- (UIViewController *)commandViewController
{
    if (self.commandType == ProfileCommandUserStrings) {
        StringrProfileTableViewController *myStringsVC = [StringrProfileTableViewController new];
        myStringsVC.userForProfile = self.user;
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            myStringsVC.delegate = self.delegate;
        }
        
        return myStringsVC;
    }
    else if (self.commandType == ProfileCommandLikedStrings) {
        StringrProfileTableViewController *myStringsVC = [StringrProfileTableViewController new];
        myStringsVC.userForProfile = self.user;
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            myStringsVC.delegate = self.delegate;
        }
        
        return myStringsVC;
    }
    else if (self.commandType == ProfileCommandLikedPhotos) {
        StringrPhotoCollectionViewController *photoCollectionVC = [[StringrPhotoCollectionViewController alloc] initWithDataType:StringrUserPhotosNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            photoCollectionVC.delegate = self.delegate;
        }
        
        return photoCollectionVC;
    }
    else if (self.commandType == ProfileCommandPublicPhotos) {
        StringrPhotoCollectionViewController *photoCollectionVC = [[StringrPhotoCollectionViewController alloc] initWithDataType:StringrUserPublicPhotosNetworkTask user:self.user];
        
        if ([self.delegate conformsToProtocol:@protocol(StringrContainerScrollViewDelegate)]) {
            photoCollectionVC.delegate = self.delegate;
        }
        
        return photoCollectionVC;
    }
    
    return [UIViewController new];
}

@end
