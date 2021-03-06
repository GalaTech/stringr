//
//  StringrConstants.m
//  Stringr
//
//  Created by Jonathan Howard on 11/18/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrConstants.h"


#pragma mark - Parse

// Production
NSString * const kStringrParseApplicationID = @"m0bUE5DhNMVo4IWlcCr5G2089J1doTDj3jGgXlzu";
NSString * const kStringrParseClientKey = @"8bfs0C7Z9kySt6uWNMYcZZIN4c6GzUZUh2pdFlxK";

// Debug
NSString * const kStringrParseDebugApplicationID = @"xHKN7JWlPi0dnaY4tasuO7bk7vmkX3ih9E7NNfc0";
NSString * const kStringrParseDebugClientKey = @"FJYQ6lIbQcfqIQbSwme5mhKH8C8jRzTeNIuCvCHL";


#pragma mark - Constant Numerical Values

float const kStringrPFObjectDetailTableViewCellHeight = 41.5;


#pragma mark - NSUserDefaults Keys

NSString * const kNSUserDefaultsWorkingStringSavedImagesKey = @"co.galatech.Stringr.userDefaults.workingString.savedImagesKey";
NSString * const kNSUserDefaultsPushNotificationsEnabledKey = @"co.galatech.Stringr.userDefaults.pushNotificationsEnabledKey";
NSString * const kNSUserDefaultsNumberOfNewActivitiesKey = @"co.galatech.Stringr.userDefaults.numberOfNewActivitiesKey";


#pragma mark - NSNotificationCenter Keys

NSString * const kNSNotificationCenterSelectedStringItemKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectItemFromCollectionView";
NSString * const kNSNotificationCenterSelectedProfileImageKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectProfileImage";
NSString * const kNSNotificationCenterSelectedCommentsButtonKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectCommentsButton";
NSString * const kNSNotificationCenterSelectedLikesButtonKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectLikesButton";
NSString * const kNSNotificationCenterUploadNewStringKey = @"co.galatech.Stringr.NSNotificationCenter.uploadNewString";
NSString * const kNSNotificationCenterDeletePhotoFromStringKey = @"co.galatech.Stringr.NSNotificationCenter.deletePhotoFromString";
NSString * const kNSNotificationCenterUpdateMenuProfileImage = @"co.galatech.Stringr.NSNotificationCenter.updateMenuProfileImage";
NSString * const kNSNotificationCenterUpdateMenuProfileName = @"co.galatech.Stringr.NSNotificationCenter.updateMenuProfileName";
NSString * const kNSNotificationCenterStringPublishedSuccessfully = @"co.galatech.Stringr.NSNotificationCenter.stringPublishedSuccessfully";
NSString * const kNSNotificationCenterStringDeletedSuccessfully = @"co.galatech.Stringr.NSNotificationCenter.stringDeletedSuccessfully";
NSString * const kNSNotificationCenterApplicationDidReceiveRemoteNotification = @"co.galatech.Stringr.NSNotificationCenter.applicationDidReceivePushNotification";
NSString * const kNSNotificationCenterRemovedPhotoFromPublicString = @"co.galatech.Stringr.NSNotificationCenter.removedPhotoFromPublicString";
NSString * const kNSNotificationCenterReloadPublicString = @"co.galatech.Stringr.NSNotificationCenter.reloadPublicString";
NSString * const kNSNotificationCenterRefreshStringDetails = @"co.galatech.Stringr.NSNotificationCenter.refreshStringDetails";


#pragma mark - Installation Class

NSString * const kStringrInstallationUserKey = @"user";
NSString * const kStringrInstallationPrivateChannelsKey = @"channels";
NSString * const kStringrUserNumberOfPreviousActivitiesKey = @"numberOfPreviousActivites";


#pragma mark - PFObject Activity Class

// Class Key
NSString * const kStringrActivityClassKey = @"Activity";

// Field Keys
NSString * const kStringrActivityTypeKey = @"type";
NSString * const kStringrActivityFromUserKey = @"fromUser";
NSString * const kStringrActivityToUserKey = @"toUser";

NSString * const kStringrActivityContentKey = @"content";
NSString * const kStringrActivityStringKey = @"string";
NSString * const kStringrActivityPhotoKey = @"photo";
NSString * const kStringrActivityCommentKey = @"comment";

// Type values
NSString * const kStringrActivityTypeLike = @"like";
NSString * const kStringrActivityTypeComment = @"comment";
NSString * const kStringrActivityTypeFollow = @"follow";
NSString * const kStringrActivityTypeJoin = @"join";
NSString * const kStringrActivityTypeMention = @"mention";
NSString * const kStringrActivityTypeAddedPhotoToPublicString = @"addedPhoto";

// Content values
NSString * const kStringrActivityContentCommentKey = @"_*_comment_*_";


#pragma mark - Statistics

// Class Key
NSString *const kStringrStatisticsClassKey = @"Statistics";

// Field Keys
NSString * const kStringrStatisticsStringKey = @"string";
NSString * const kStringrStatisticsLikeCountKey = @"likeCount";
NSString * const kStringrStatisticsCommentCountKey = @"commentCount";


#pragma mark - PFObject User Class

// Class Key
NSString * const kStringrUserClassKey = @"User";

// Field Keys
NSString * const kStringrUserUsernameKey = @"username";
NSString * const kStringrUserUsernameCaseSensitive = @"usernameCaseSensitive";
NSString * const kStringrUserDisplayNameKey = @"displayName";
NSString * const kStringrUserDisplayNameCaseInsensitiveKey = @"displayNameCaseInsensitive";
NSString * const kStringrUserFacebookIDKey = @"facebookID";
NSString * const kStringrUserTwitterIDKey = @"twitterID";
NSString * const kStringrUserProfilePictureURLKey = @"profilePictureURL";
NSString * const kStringrUserEmailVerifiedKey = @"emailVerified";
NSString * const kStringrUserSocialNetworkSignupCompleteKey = @"socialNetworkSignupComplete";

NSString * const kStringrUserProfilePictureKey = @"profileImage";
NSString * const kStringrUserProfilePictureThumbnailKey = @"profileImageThumbnail";

NSString * const kStringrUserDescriptionKey = @"description";
NSString * const kStringrUserLocationKey = @"geoLocation";
NSString * const kStringrUserSelectedUniversityKey = @"selectedUniversityName";
NSString * const kStringrUserUniversitiesKey = @"universityNames";
NSString * const kStringrUserNumberOfStringsKey = @"numberOfStrings";

NSString * const kStringrUserPrivateChannelKey = @"channel";


#pragma mark - PFObject Photo Class

// Class Key
NSString * const kStringrPhotoClassKey = @"Photo";

// Field Keys
NSString * const kStringrPhotoPictureKey = @"image";
NSString * const kStringrPhotoThumbnailKey = @"thumbnail";
NSString * const kStringrPhotoUserKey = @"user";
NSString * const kStringrPhotoStringKey = @"string";
NSString * const kStringrPhotoCaptionKey = @"caption";
NSString * const kStringrPhotoDescriptionKey = @"description";
NSString * const kStringrPhotoPictureWidth = @"imageWidth";
NSString * const kStringrPhotoPictureHeight = @"imageHeight";
NSString * const kStringrPhotoThumbnailWidth = @"thumbnailWidth";
NSString * const kStringrPhotoThumbnailHeight = @"thumbnailHeight";
NSString * const kStringrPhotoOrderNumber = @"photoOrder";
NSString * const kStringrPhotoNumberOfLikesKey = @"numberOfLikes";
NSString * const kStringrPhotoNumberOfCommentsKey = @"numberOfComments";


#pragma mark - PFObject StringrString class

// Class Key
NSString * const kStringrStringClassKey = @"String";

// Field Keys
NSString * const kStringrStringPhotosKey = @"photos";
NSString * const kStringrStringUserKey = @"user";
NSString * const kStringrStringTitleKey = @"title";
NSString * const kStringrStringDescriptionKey = @"description";
NSString * const kStringrStringStatisticsKey = @"statistics";
NSString * const kStringrStringLocationKey = @"location";


#pragma mark - Cached User Attributes

NSString * const kStringrUserAttributesIsFollowedByCurrentUserKey = @"isFollowedByCurrentUser";
NSString * const kStringrUserAttributesStringCountKey = @"stringCount";
NSString * const kStringrUserAttributesFollowingCountKey = @"followingCount";
NSString * const kStringrUserAttributesFollowerCountKey = @"followerCount";


#pragma mark - Cached Photo Attributes

NSString * const kStringrPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString * const kStringrPhotoAttributesLikeCountKey = @"likeCount";
NSString * const kStringrPhotoAttributesCommentCountKey = @"commentCount";


#pragma mark - Cached String Attributes

NSString * const kStringrStringAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString * const kStringrStringAttributesLikeCountKey = @"likeCount";
NSString * const kStringrStringAttributesCommentCountKey = @"commentCount";


#pragma mark - PFPush Notification Payload Keys

NSString * const kAPNSAlertKey = @"alert";
NSString * const kAPNSBadgeKey = @"badge";
NSString * const kAPNSSoundKey = @"sound";

NSString * const kStringrPushPayloadPayloadTypeKey = @"p";
NSString * const kStringrPushPayloadPayloadTypeActivityKey = @"a";

NSString * const kStringrPushPayloadActivityTypeKey = @"t";
NSString * const kStringrPushPayloadActivityLikeKey = @"l";
NSString * const kStringrPushPayloadActivityCommentKey = @"c";
NSString * const kStringrPushPayloadActivityFollowKey = @"f";

NSString * const kStringrPushPayloadFromUserObjectIdKey = @"fu";
NSString * const kStringrPushPayloadToUserObjectIdKey = @"tu";
NSString * const kStringrPushPayloadPhotoObjectIdKey = @"pid";
NSString * const kStringrPushPayloadStringObjectIDKey = @"sid";
NSString * const kStringrPushPayloadCommentObjectIDKey = @"cid";


#pragma mark - Storyboard Ids

// Init and Login
NSString * const kStoryboardRootViewID = @"rootVC";
NSString * const kStoryboardLoginID = @"loginVC";
NSString * const kStoryboardMenuID = @"StringrMenuViewController";

// Signup
NSString * const kStoryboardSignupWithEmailID = @"signupWithEmailVC";
NSString * const kStoryboardEmailVerificationID = @"emailVerificationVC";
NSString * const kStoryboardSignupWithSocialNetworkID = @"signupWithSocialNetworkVC";

// Profile
NSString * const kStoryboardProfileID = @"profileVC";
NSString * const kStoryboardProfileTopViewID = @"TopProfileVC";
NSString * const kStoryboardProfileTableViewID = @"TableProfileVC";
NSString * const kStoryboardProfileConnectionsID = @"FollowersVC";
NSString * const kStoryboardEditProfileID = @"EditProfileVC";

// String Tables
NSString * const kStoryboardStringTableID = @"stringTableVC";
NSString * const kStoryboardMyStringsID = @"MyStringsVC";
NSString * const kStoryboardLikedStringsID = @"LikedStringsVC";

// Comments/Writing
NSString * const kStoryboardCommentsID = @"StringCommentsVC";
NSString * const kStoryboardWriteCommentID = @"writeCommentVC";
NSString * const kStoryboardWriteAndEditID = @"writeAndEditVC";

// String Detail
NSString * const kStoryboardStringDetailID = @"stringDetailVC";
NSString * const kStoryboardStringDetailTopViewID = @"stringDetailTopVC";
NSString * const kStoryboardStringDetailTableViewID = @"stringDetailTableVC";
NSString * const kStoryboardEditStringDetailTopViewID = @"stringDetailEditTopVC";
NSString * const kStoryboardEditStringDetailTableViewID = @"stringDetailEditTableVC";

// Photo Detail
NSString * const kStoryboardPhotoDetailID = @"photoDetailVC";
NSString * const kStoryboardPhotoDetailTopViewID = @"photoDetailTopVC";
NSString * const kStoryboardPhotoDetailTableViewID = @"photoDetailTableVC";
NSString * const kStoryboardEditPhotoDetailTableViewID = @"photoDetailEditTableVC";

// Activity
NSString * const kStoryboardActivityTableID = @"activityVC";

// Search
NSString * const kStoryboardSearchStringsID = @"SearchStringsVC";
NSString * const kStoryboardSearchUsersID = @"SearchFindPeopleVC";

// Settings
NSString * const kStoryboardSettingsID = @"SettingsVC";
NSString * const kStoryboardFindAndInviteFriendsID = @"findAndInviteFriendsVC";
NSString * const kStoryboardPrivacyPolicyToSID = @"privacyPolicyToSVC";


#pragma mark - Helpers

NSString * const kStringrFlaggedContentClassKey = @"Flagged";
NSString * const kStringrFlaggedPhotoKey = @"flaggedPhoto";
NSString * const kStringrFlaggedStringKey = @"flaggedString";
NSString * const kStringrFlaggedUserKey = @"flaggedUser";
NSString * const kstringrFlaggingUserKey = @"flaggingUser";

