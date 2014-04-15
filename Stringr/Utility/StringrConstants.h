//
//  StringrConstants.h
//  Stringr
//
//  Created by Jonathan Howard on 11/18/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface StringrConstants : NSObject


#pragma mark - Colors

+ (UIColor *)kStringrRedColor;
+ (UIColor *)kStringrOrangeColor;
+ (UIColor *)kStringrYellowColor;
+ (UIColor *)kStringrGreenColor;
+ (UIColor *)kStringrTurquoiseColor;
+ (UIColor *)kStringrBlueColor;
+ (UIColor *)kStringrPurpleColor;
+ (UIColor *)kStringTableViewBackgroundColor;
+ (UIColor *)kStringCollectionViewBackgroundColor;


@end

#pragma mark - Constant Numerical Values

extern float const kStringrPFObjectDetailTableViewCellHeight;

#pragma mark - NSUserDefaults Keys

extern NSString * const kUserDefaultsWorkingStringSavedImagesKey;


#pragma mark - NSNotificationCenter Keys

//extern NSString * const kNSNotificationCenterSelectedStringItemKey;
//extern NSString * const kNSNotificationCenterSelectedProfileImageKey;
//extern NSString * const kNSNotificationCenterSelectedCommentsButtonKey;
//extern NSString * const kNSNotificationCenterSelectedLikesButtonKey;
extern NSString * const kNSNotificationCenterUploadNewStringKey;
extern NSString * const kNSNotificationCenterDeletePhotoFromStringKey;
extern NSString * const kNSNotificationCenterUpdateMenuProfileImage;
extern NSString * const kNSNotificationCenterUpdateMenuProfileName;
extern NSString * const kNSNotificationCenterStringPublishedSuccessfully;
extern NSString * const kNSNotificationCenterStringDeletedSuccessfully;


#pragma mark - PFObject Activity Class
// Class Key
extern NSString * const kStringrActivityClassKey;

// Field Keys
extern NSString * const kStringrActivityTypeKey;
extern NSString * const kStringrActivityFromUserKey;
extern NSString * const kStringrActivityToUserKey;
extern NSString * const kStringrActivityContentKey;
extern NSString * const kStringrActivityStringKey; // gives you a String PFObject
extern NSString * const kStringrActivityPhotoKey; // gives you a photo PFObject

// Type values
extern NSString * const kStringrActivityTypeLike;
extern NSString * const kStringrActivityTypeComment;
extern NSString * const kStringrActivityTypeFollow;
extern NSString * const kStringrActivityTypeJoin;


#pragma mark - PFObject User Class

// Class Key
extern NSString * const kStringrUserClassKey;

// Field Keys
extern NSString * const kStringrUserUsernameKey;
extern NSString * const kStringrUserUsernameCaseSensitive;
extern NSString * const kStringrUserDisplayNameKey;
extern NSString * const kStringrUserFacebookIDKey;
extern NSString * const kStringrUserTwitterIDKey;
extern NSString * const kStringrUserProfilePictureURLKey;
extern NSString * const kStringrUserEmailVerifiedKey;
extern NSString * const kStringrUserSocialNetworkSignupCompleteKey;

extern NSString * const kStringrUserProfilePictureThumbnailKey;
extern NSString * const kStringrUserProfilePictureKey;

extern NSString * const kStringrUserDescriptionKey;
extern NSString * const kStringrUserLocationKey;
//extern NSString * const kStringrUserSelectedUniversityKey;
//extern NSString * const kStringrUserUniversitiesKey;
extern NSString * const kStringrUserNumberOfStringsKey;

extern NSString * const kStringrUserPrivateChannelKey;




#pragma mark - PFObject String class
// Class Key
extern NSString * const kStringrStringClassKey;

// Field Keys
extern NSString * const kStringrStringPhotosKey;
extern NSString * const kStringrStringUserKey;
extern NSString * const kStringrStringTitleKey;
extern NSString * const kStringrStringDescriptionKey;
//extern NSString * const kStringrStringNumberOfLikesKey;
//extern NSString * const kStringrStringNumberOfCommentsKey;



#pragma mark - PFObject Photo Class
// Class Key
extern NSString * const kStringrPhotoClassKey;

// Field Keys
extern NSString * const kStringrPhotoPictureKey;
extern NSString * const kStringrPhotoThumbnailKey;
extern NSString * const kStringrPhotoUserKey;
extern NSString * const kStringrPhotoStringKey;
extern NSString * const kStringrPhotoCaptionKey;
extern NSString * const kStringrPhotoDescriptionKey;
extern NSString * const kStringrPhotoPictureWidth;
extern NSString * const kStringrPhotoPictureHeight;
extern NSString * const kStringrPhotoOrderNumber;
extern NSString * const kStringrPhotoThumbnailWidth;
extern NSString * const kStringrPhotoThumbnailHeight;
//extern NSString * const kStringrPhotoNumberOfLikesKey;
//extern NSString * const kStringrPhotoNumberOfCommentsKey;



#pragma mark - Cached User Attributes

extern NSString * const kStringrUserAttributesIsFollowedByCurrentUserKey;
extern NSString * const kStringrUserAttributesStringCountKey;



#pragma mark - Cached Photo Attributes

extern NSString * const kStringrPhotoAttributesIsLikedByCurrentUserKey;
extern NSString * const kStringrPhotoAttributesLikeCountKey;
extern NSString * const kStringrPhotoAttributesCommentCountKey;



#pragma mark - Cached String Attributes

extern NSString * const kStringrStringAttributesIsLikedByCurrentUserKey;
extern NSString * const kStringrStringAttributesLikeCountKey;
extern NSString * const kStringrStringAttributesCommentCountKey;



