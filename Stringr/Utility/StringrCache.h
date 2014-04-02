//
//  StringrCache.h
//  Stringr
//
//  Created by Jonathan Howard on 3/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrCache : NSObject

+ (instancetype)sharedCache;

- (void)clear;

// user
- (NSDictionary *)attributesForUser:(PFUser *)user;
- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user;
- (void)setAttributesForUser:(PFUser *)user stringCount:(NSNumber *)count followedByCurrentUser:(BOOL)followed;

- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following forUser:(PFUser *)user;


// photo
- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
- (void)setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo;
- (void)setAttributesForPhoto:(PFObject *)photo likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser;

- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo;
- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;

- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
- (void)incrementLikeCountForPhoto:(PFObject *)photo;
- (void)decrementLikeCountForPhoto:(PFObject *)photo;

- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
- (void)incrementCommentCountForPhoto:(PFObject *)photo;
- (void)decrementCommentCountForPhoto:(PFObject *)photo;


// string
- (NSDictionary *)attributesForString:(PFObject *)string;
- (void)setAttributes:(NSDictionary *)attributes forString:(PFObject *)string;
- (void)setAttributesForString:(PFObject *)string likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser;

- (BOOL)isStringLikedByCurrentUser:(PFObject *)string;
- (void)setStringIsLikedByCurrentUser:(PFObject *)string liked:(BOOL)liked;

- (NSNumber *)likeCountForString:(PFObject *)string;
- (void)incrementLikeCountForString:(PFObject *)string;
- (void)decrementLikeCountForString:(PFObject *)string;

- (NSNumber *)commentCountForString:(PFObject *)string;
- (void)incrementCommentCountForString:(PFObject *)string;
- (void)decrementCommentCountForString:(PFObject *)string;



@end
