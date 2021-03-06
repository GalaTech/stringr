//
//  StringrUtility.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrUtility : NSObject

// Like/Unlike
+ (void)likeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikeObjectInBackground:(PFObject *)object block:(void (^)(BOOL succeeded, NSError *error))completionBlock;


// Follow/Unfollow
+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;


// Push Notification's
+ (void)sendFollowingPushNotification:(PFUser *)user;


//Activities
+ (PFQuery *)queryForActivitiesOnObject:(PFObject *)object cachePolicy:(PFCachePolicy)cachePolicy;

/**
 * Provides all of the activities that are associated with the provided photo PFObject.
 * Includes likes, comments, the photo object itself, and the user that owns that photo.
 * @param photo The photo object that will be querried for its activities
 * @param cachePolicy The caching policy that we want to use on this query
 * @return A query that will contain all of the activities for the specified photo
 */
+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;

/**
 * Provides all of the activities that are associated with the provided string PFObject.
 * Includes likes, comments, the string object itself, and the user that owns that string.
 * @param string The string object that will be querried for its activities
 * @param cachePolicy The caching policy that we want to use on this query
 * @return A query that will contain all of the activites for the specified string
 */
+ (PFQuery *)queryForActivitiesOnString:(PFObject *)string cachePolicy:(PFCachePolicy)cachePolicy;

/**
 * Returns whether or not the passed in PFObject is of the String class.
 * This method will only compare for String and Photo class objects. It will
 * return NO for anything else. 
 * @param object The PFObject passed in to test if it is of type string
 * @return YES if the object is of type String and NO if it is of type Photo.
 */
+ (BOOL)objectIsString:(PFObject *)object;


// UIImage Formatting
+ (UIImage *)formatPhotoImageForUpload:(UIImage *)image;
+ (UIImage *)formatProfileImageForUpload:(UIImage *)image;
+ (UIImage *)formatProfileThumbnailImageForUpload:(UIImage *)image;


// Text Parsing
/**
 * Receives an NSDate object and will return an NSString stating in normal English
 * how long ago that date way. 10 seconds ago, 1 week ago, 6 months ago, etc.
 * @param date The date provided that will be parsed into an English format of time displacement.
 * @return A string will state a date in plain english: '15 minutes ago'
 */
+ (NSString *)timeAgoFromDate:(NSDate *)date;

/**
 * Checks to see if a string is in a valid email format
 * @param checkString The string that will be evaluated to see if it is a valid email format
 * @return YES if the string is a valid email format. NO if it is not.
 */
+ (BOOL)NSStringIsValidEmail:(NSString *)checkString;

/**
 * Checks to see if a string contains characters after removing all whitespace.
 * @param checkString The string that will be evaluated to see if it contains any whitespace.
 * @return YES if the string does contain characters after removing all whitespace. NO if the 
 * string happened to only contain whitespace.
 */
+ (BOOL)NSStringContainsCharactersWithoutWhiteSpace:(NSString *)checkString;

// Trim the input string by removing leading and trailing white spaces
// and return the result
+ (NSString *)stringTrimmedForLeadingAndTrailingWhiteSpacesFromString:(NSString *)string;

/**
 * Checks to see if a string contains valid characters for creating a username.
 * Valid characters consist of: A-Z a-z 0-9 . _ -
 * The string is also checked to see if it has whitespace. The 'space' character is not considered a
 * valid character.
 * Usernames must also be in between 1 and 15 characters in length.
 * @param checkString The string that will be evaluated to see if it is entirely made up of valid characters.
 * @return YES if the string is entirely made up of valid characters and is in between 1 and 15 characters in length. 
 * NO if it is not.
 */
+ (BOOL)NSStringIsValidUsername:(NSString *)checkString;

+ (NSString *)usernameFormattedWithMentionSymbol:(NSString *)username;

+ (NSString *)randomStringWithLength:(int)length;

+ (CGFloat)heightForLabelWithNSString:(NSString *)text;
+ (CGFloat)heightForLabelWithNSString:(NSString *)text labelSize:(CGSize)size andAttributes:(NSDictionary *)attributes;

+ (NSArray *)mentionsContainedWithinString:(NSString *)string;


+ (BOOL)facebookUserCanLogin:(PFUser *)facebookUser;
+ (BOOL)twitterUserCanLogin:(PFUser *)twitterUser;
+ (BOOL)usernameUserCanLogin:(PFUser *)usernameUser;
+ (BOOL)usernameUserNeedsToVerifyEmail:(PFUser *)usernameUser;


+ (PFObject *)stringFromObject:(PFObject *)object;

@end
