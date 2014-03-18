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

+ (UIColor *)kStringrRedColor
{
    return [UIColor colorWithRed:254.0f / 255.0f green:17.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)kStringrOrangeColor
{
    return [UIColor colorWithRed:255.0f / 255.0f green:107.0f / 255.0f blue:1.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)kStringrYellowColor
{
    return [UIColor colorWithRed:255.0f / 255.0f green:185.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)kStringrGreenColor
{
    return [UIColor colorWithRed:67.0f / 255.0f green:167.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)kStringrTurquoiseColor
{
    return [UIColor colorWithRed:1.0f / 255.0f green:152.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)kStringrBlueColor
{
    return [UIColor colorWithRed:10.0f / 255.0f green:81.0f / 255.0f blue:147.0f / 161.0f alpha:1.0f];
}

+ (UIColor *)kStringrPurpleColor
{
    return [UIColor colorWithRed:71.0f / 255.0f green:12.0f / 255.0f blue:128.0f / 255.0f alpha:1.0f];
}

@end


#pragma mark - Constant Numerical Values

float const kStringrPFObjectDetailTableViewCellHeight = 41.5;



#pragma mark - NSUserDefaults Keys

NSString * const kUserDefaultsWorkingStringSavedImagesKey = @"co.galatech.Stringr.userDefaults.workingString.savedImagesKey";


#pragma mark - NSNotificationCenter Keys
NSString * const kNSNotificationCenterSelectedStringItemKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectItemFromCollectionView";
NSString * const kNSNotificationCenterSelectedProfileImageKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectProfileImage";
NSString * const kNSNotificationCenterSelectedCommentsButtonKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectCommentsButton";
NSString * const kNSNotificationCenterSelectedLikesButtonKey = @"co.galatech.Stringr.NSNotificationCenter.didSelectLikesButton";
NSString * const kNSNotificationCenterUploadNewStringKey = @"co.galatech.Stringr.NSNotificationCenter.uploadNewString";
NSString * const kNSNotificationCenterDeletePhotoFromStringKey = @"co.galatech.Stringr.NSNotificationCenter.deletePhotoFromString";
NSString * const kNSNotificationCenterUpdateMenuProfileImage = @"co.galatech.Stringr.NSNotificationCenter.updateMenuProfileImage";
NSString * const kNSNotificationCenterUpdateMenuProfileName = @"co.galatech.Stringr.NSNotificationCenter.updateMenuProfileName";




#pragma mark - PFObject Activity Class
// Class Key
NSString * const kStringrActivityClassKey = @"Activity";

// Field Keys
NSString * const kStringrActivityTypeKey = @"type";
NSString * const kStringrFromUserKey = @"fromUser";
NSString * const kStringrToUserKey = @"toUser";

NSString * const kStringrContentKey = @"content";
NSString * const kStringrStringKey = @"string";
NSString * const kStringrPhotoKey = @"photo";


// Type values
NSString * const kStringrActivityTypeLike = @"like";
NSString * const kStringrActivityTypeComment = @"comment";
NSString * const kStringrActivityTypeFollow = @"follow";
NSString * const kStringrActivityTypeJoin = @"join";
//NSString * const kStringrActivityTypePhotoLike = @"photoLike";
//NSString * const kStringrActivityTypePhotoComment = @"photoComment";


#pragma mark - PFObject User Class
// Class Key
NSString * const kStringrUserClassKey = @"User";

// Field Keys
NSString * const kStringrUserDisplayNameKey = @"displayName";
NSString * const kStringrFacebookIDKey = @"facebookID";
NSString * const kStringrFacebookProfilePictureURLKey = @"facebookProfilePictureURL";

NSString * const kStringrUserProfilePictureKey = @"profileImage";
NSString * const kStringrUserProfilePictureThumbnailKey = @"profileImageThumbnail";

NSString * const kStringrUserDescriptionKey = @"description";
NSString * const kStringrUserLocationKey = @"location";
NSString * const kStringrUserSelectedUniversityKey = @"selectedUniversityName";
NSString * const kStringrUserUniversitiesKey = @"universityNames";
NSString * const kStringrUserNumberOfStringsKey = @"numberOfStrings";

NSString * const kStringrUserPrivateChannelKey = @"channel";




#pragma mark - PFObject StringrString class
// Class Key
NSString * const kStringrStringClassKey = @"String";

// Field Keys
NSString * const kStringrStringPhotosKey = @"photos";
NSString * const kStringrStringUserKey = @"user";
NSString * const kStringrStringTitleKey = @"title";
NSString * const kStringrStringDescriptionKey = @"description";



#pragma mark - PFObject Photo Class
// Class Key
NSString * const kStringrPhotoClassKey = @"Photo";

// Field Keys
NSString * const kStringrPhotoPictureKey = @"image";
NSString * const kStringrPhotoThumbnailKey = @"thumbnail";
NSString * const kStringrPhotoUserKey = @"user";
NSString * const kStringrPhotoStringKey = @"string";
NSString * const kStringrPhotoCaptionKey = @"caption";
NSString * const kStringrPhotoPictureWidth = @"imageWidth";
NSString * const kStringrPhotoPictureHeight = @"imageHeight";
NSString * const kStringrPhotoThumbnailWidth = @"thumbnailWidth";
NSString * const kStringrPhotoThumbnailHeight = @"thumbnailHeight";

