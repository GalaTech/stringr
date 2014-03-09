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
extern NSString * const kStringrStringKey; // gives you a String PFObject
extern NSString * const kStringrPhotoKey; // gives you a photo PFObject

// Type values
extern NSString * const kStringrActivityTypeLike;
extern NSString * const kStringrActivityTypeComment;
extern NSString * const kStringrActivityTypeFollow;
extern NSString * const kStringrActivityTypeJoin;


#pragma mark - PFObject User Class
// Field Keys
extern NSString * const kStringrUserDisplayNameKey;
extern NSString * const kStringrFacebookIDKey;
extern NSString * const kStringrFacebookProfilePictureURLKey;

extern NSString * const kStringrUserProfilePictureThumbnailKey;
extern NSString * const kStringrUserProfilePictureKey;

extern NSString * const kStringrUserDescriptionKey;
extern NSString * const kStringrUserLocationKey;
extern NSString * const kStringrUserSelectedUniversityKey;
extern NSString * const kStringrUserUniversitiesKey;

extern NSString * const kStringrUserPrivateChannelKey;




#pragma mark - PFObject String class
// Class Key
extern NSString * const kStringrStringClassKey;

// Field Keys
extern NSString * const kStringrStringPhotosKey;
extern NSString * const kStringrStringUserKey;
extern NSString * const kStringrStringTitleKey;
extern NSString * const kStringrStringDescriptionKey;




#pragma mark - PFObject Photo Class
// Class Key
extern NSString * const kStringrPhotoClassKey;

// Field Keys
extern NSString * const kStringrPhotoPictureKey;
extern NSString * const kStringrPhotoThumbnailKey;
extern NSString * const kStringrPhotoUserKey;
extern NSString * const kStringrPhotoStringKey;
extern NSString * const kStringrPhotoCaptionKey;
extern NSString * const kStringrPhotoPictureWidth;
extern NSString * const kStringrPhotoPictureHeight;
extern NSString * const kStringrPhotoThumbnailWidth;
extern NSString * const kStringrPhotoThumbnailHeight;



