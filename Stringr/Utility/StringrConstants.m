//
//  StringrConstants.m
//  Stringr
//
//  Created by Jonathan Howard on 11/18/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrConstants.h"

@implementation StringrConstants

+ (UIColor *)kStringTableViewBackgroundColor
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

+ (UIColor *)kStringCollectionViewBackgroundColor
{
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}

@end


#pragma mark - NSUserDefaults Keys

NSString * const kUserDefaultsWorkingStringSavedImagesKey = @"co.galatech.Stringr.userDefaults.workingString.savedImagesKey";


#pragma mark - PFObject Activity Class
// Class Key
NSString * const kStringrActivityClassKey;

// Field Keys
NSString * const kStringrActivityTypeKey;
NSString * const kStringrFromUserKey;
NSString * const kStringrToUserKey;
NSString * const kStringrContentKey;
NSString * const kStringrPhotoKey;


// Type values
NSString * const kStringrActivityTypeStringLike;
NSString * const kStringrActivityTypeStringComment;

NSString * const kStringrActivityTypePhotoLike;
NSString * const kStringrActivityTypePhotoComment;

NSString * const kStringrActivityTypeFollow;
NSString * const kStringrActivityTypeJoin;


#pragma mark - PFObject User Class
// Field Keys
NSString * const kStringrUserDisplayNameKey;
NSString * const kStringrFacebookIDKey;

NSString * const kStringrUserProfilePicThumbnailKey;
NSString * const kStringrUserProfilePicKey;

NSString * const kStringrUserAboutDescriptionKey;
NSString * const kStringrUserUniversityKey;

NSString * const kStringrUserPrivateChannelKey;




#pragma mark - PFObject StringrString class
// Class Key
NSString * const kStringrStringClassKey;

// Field Keys




#pragma mark - PFObject Photo Class
// Class Key
NSString * const kStringrPhotoClassKey;

// Field Keys
