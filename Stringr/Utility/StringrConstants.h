//
//  StringrConstants.h
//  Stringr
//
//  Created by Jonathan Howard on 11/18/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface StringrConstants : NSObject

+ (UIColor *)kStringTableViewBackgroundColor;
+ (UIColor *)kStringCollectionViewBackgroundColor;

@end

#pragma mark - NSUserDefaults Keys

extern NSString * const kUserDefaultsWorkingStringSavedImagesKey;


#pragma mark - NSNotificationCenter Keys

extern NSString * const kNSNotificationCenterSelectedStringItemKey;
extern NSString * const kNSNotificationCenterSelectedProfileImageKey;
extern NSString * const kNSNotificationCenterSelectedCommentsButtonKey;
extern NSString * const kNSNotificationCenterSelectedLikesButtonKey;
extern NSString * const kNSNotificationCenterUploadNewStringKey;
extern NSString * const kNSNotificationCenterDeletePhotoFromStringKey;
extern NSString * const kNSNotificationCenterUpdateMenuProfileImage;
extern NSString * const kNSNotificationCenterUpdateMenuProfileName;


#pragma mark - PFObject Activity Class
// Class Key
extern NSString * const kStringrActivityClassKey;

// Field Keys
extern NSString * const kStringrActivityTypeKey;
extern NSString * const kStringrFromUserKey;
extern NSString * const kStringrToUserKey;
extern NSString * const kStringrContentKey;
extern NSString * const kStringrPhotoKey;


// Type values
extern NSString * const kStringrActivityTypeStringLike;
extern NSString * const kStringrActivityTypeStringComment;

extern NSString * const kStringrActivityTypePhotoLike;
extern NSString * const kStringrActivityTypePhotoComment;

extern NSString * const kStringrActivityTypeFollow;
extern NSString * const kStringrActivityTypeJoin;


#pragma mark - PFObject User Class
// Field Keys
extern NSString * const kStringrUserDisplayNameKey;
extern NSString * const kStringrFacebookIDKey;

extern NSString * const kStringrUserProfilePicThumbnailKey;
extern NSString * const kStringrUserProfilePicKey;

extern NSString * const kStringrUserAboutDescriptionKey;
extern NSString * const kStringrUserUniversityKey;

extern NSString * const kStringrUserPrivateChannelKey;




#pragma mark - PFObject StringrString class
// Class Key
extern NSString * const kStringrStringClassKey;

// Field Keys




#pragma mark - PFObject Photo Class
// Class Key
extern NSString * const kStringrPhotoClassKey;

// Field Keys
