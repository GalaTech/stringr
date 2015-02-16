//
//  StringrConstants.h
//  Stringr
//
//  Created by Jonathan Howard on 11/18/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Parse Constants

// Production
extern NSString * const kStringrParseApplicationID;
extern NSString * const kStringrParseClientKey;

// Debug
extern NSString * const kStringrParseDebugApplicationID;
extern NSString * const kStringrParseDebugClientKey;

#pragma mark - Constant Numerical Values

extern float const kStringrPFObjectDetailTableViewCellHeight;


#pragma mark - NSUserDefaults Keys

extern NSString * const kNSUserDefaultsWorkingStringSavedImagesKey;
extern NSString * const kNSUserDefaultsPushNotificationsEnabledKey;
extern NSString * const kNSUserDefaultsNumberOfNewActivitiesKey;


#pragma mark - NSNotificationCenter Keys

extern NSString * const kNSNotificationCenterUploadNewStringKey;
extern NSString * const kNSNotificationCenterDeletePhotoFromStringKey;
extern NSString * const kNSNotificationCenterUpdateMenuProfileImage;
extern NSString * const kNSNotificationCenterUpdateMenuProfileName;
extern NSString * const kNSNotificationCenterStringPublishedSuccessfully;
extern NSString * const kNSNotificationCenterStringDeletedSuccessfully;
extern NSString * const kNSNotificationCenterApplicationDidReceiveRemoteNotification;
extern NSString * const kNSNotificationCenterRemovedPhotoFromPublicString;
extern NSString * const kNSNotificationCenterReloadPublicString;
extern NSString * const kNSNotificationCenterRefreshStringDetails;


#pragma mark - Installation Class

extern NSString * const kStringrInstallationUserKey;
extern NSString * const kStringrInstallationPrivateChannelsKey;
extern NSString * const kStringrUserNumberOfPreviousActivitiesKey;


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
extern NSString * const kStringrActivityCommentKey;

// Type values
extern NSString * const kStringrActivityTypeLike;
extern NSString * const kStringrActivityTypeComment;
extern NSString * const kStringrActivityTypeFollow;
extern NSString * const kStringrActivityTypeJoin;
extern NSString * const kStringrActivityTypeMention;
extern NSString * const kStringrActivityTypeAddedPhotoToPublicString;

// Content values
extern NSString * const kStringrActivityContentCommentKey;


#pragma mark - Statistics

// Class Key
extern NSString *const kStringrStatisticsClassKey;

// Field Keys
extern NSString * const kStringrStatisticsStringKey;
extern NSString * const kStringrStatisticsLikeCountKey;
extern NSString * const kStringrStatisticsCommentCountKey;


#pragma mark - PFObject User Class

// Class Key
extern NSString * const kStringrUserClassKey;

// Field Keys
extern NSString * const kStringrUserUsernameKey;
extern NSString * const kStringrUserUsernameCaseSensitive;
extern NSString * const kStringrUserDisplayNameKey;
extern NSString * const kStringrUserDisplayNameCaseInsensitiveKey;
extern NSString * const kStringrUserFacebookIDKey;
extern NSString * const kStringrUserTwitterIDKey;
extern NSString * const kStringrUserProfilePictureURLKey;
extern NSString * const kStringrUserEmailVerifiedKey;
extern NSString * const kStringrUserSocialNetworkSignupCompleteKey;

extern NSString * const kStringrUserProfilePictureThumbnailKey;
extern NSString * const kStringrUserProfilePictureKey;

extern NSString * const kStringrUserDescriptionKey;
extern NSString * const kStringrUserLocationKey;
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
extern NSString * const kStringrStringStatisticsKey;
extern NSString * const kStringrStringLocationKey;
extern NSString * const kStringrStringLikeCountKey;
extern NSString * const kStringrStringCommentCountKey;


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
extern NSString * const kStringrUserAttributesFollowingCountKey;
extern NSString * const kStringrUserAttributesFollowerCountKey;


#pragma mark - Cached Photo Attributes

extern NSString * const kStringrPhotoAttributesIsLikedByCurrentUserKey;
extern NSString * const kStringrPhotoAttributesLikeCountKey;
extern NSString * const kStringrPhotoAttributesCommentCountKey;


#pragma mark - Cached String Attributes

extern NSString * const kStringrStringAttributesIsLikedByCurrentUserKey;
extern NSString * const kStringrStringAttributesLikeCountKey;
extern NSString * const kStringrStringAttributesCommentCountKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString * const kAPNSAlertKey;
extern NSString * const kAPNSBadgeKey;
extern NSString * const kAPNSSoundKey;

extern NSString * const kStringrPushPayloadPayloadTypeKey;
extern NSString * const kStringrPushPayloadPayloadTypeActivityKey;

extern NSString * const kStringrPushPayloadActivityTypeKey;
extern NSString * const kStringrPushPayloadActivityLikeKey;
extern NSString * const kStringrPushPayloadActivityCommentKey;
extern NSString * const kStringrPushPayloadActivityFollowKey;

extern NSString * const kStringrPushPayloadFromUserObjectIdKey;
extern NSString * const kStringrPushPayloadToUserObjectIdKey;
extern NSString * const kStringrPushPayloadPhotoObjectIdKey;
extern NSString * const kStringrPushPayloadStringObjectIDKey;
extern NSString * const kStringrPushPayloadCommentObjectIDKey;


#pragma mark - Storyboard Ids

extern NSString * const kStoryboardRootViewID;
extern NSString * const kStoryboardLoginID;
extern NSString * const kStoryboardMenuID;

extern NSString * const kStoryboardSignupWithEmailID;
extern NSString * const kStoryboardEmailVerificationID;
extern NSString * const kStoryboardSignupWithSocialNetworkID;

extern NSString * const kStoryboardProfileID;
extern NSString * const kStoryboardProfileTableViewID;
extern NSString * const kStoryboardProfileTopViewID;
extern NSString * const kStoryboardProfileConnectionsID;
extern NSString * const kStoryboardEditProfileID;

extern NSString * const kStoryboardStringTableID;
extern NSString * const kStoryboardMyStringsID;
extern NSString * const kStoryboardLikedStringsID;

extern NSString * const kStoryboardCommentsID;
extern NSString * const kStoryboardWriteCommentID;
extern NSString * const kStoryboardWriteAndEditID;

extern NSString * const kStoryboardStringDetailID;
extern NSString * const kStoryboardStringDetailTableViewID;
extern NSString * const kStoryboardStringDetailTopViewID;
extern NSString * const kStoryboardEditStringDetailTableViewID;
extern NSString * const kStoryboardEditStringDetailTopViewID;

extern NSString * const kStoryboardPhotoDetailID;
extern NSString * const kStoryboardPhotoDetailTableViewID;
extern NSString * const kStoryboardPhotoDetailTopViewID;
extern NSString * const kStoryboardEditPhotoDetailTableViewID;

extern NSString * const kStoryboardActivityTableID;

extern NSString * const kStoryboardSearchStringsID;
extern NSString * const kStoryboardSearchUsersID;

extern NSString * const kStoryboardSettingsID;
extern NSString * const kStoryboardFindAndInviteFriendsID;
extern NSString * const kStoryboardPrivacyPolicyToSID;


#pragma mark - Helpers

extern NSString * const kStringrFlaggedContentClassKey;
extern NSString * const kStringrFlaggedPhotoKey;
extern NSString * const kStringrFlaggedStringKey;
extern NSString * const kStringrFlaggedUserKey;
extern NSString * const kstringrFlaggingUserKey;



