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

- (NSNumber *)stringCountForUser:(PFUser *)user;
- (void)setStringCount:(NSNumber *)count forUser:(PFUser *)user;

- (NSNumber *)followingCountForUser:(PFUser *)user;
- (void)setFollowingCount:(NSNumber *)count forUser:(PFUser *)user;

- (NSNumber *)followerCountForUser:(PFUser *)user;
- (void)setFollowerCount:(NSNumber *)count forUser:(PFUser *)user;



// object (String or Photo)
- (NSDictionary *)attributesForObject:(PFObject *)object;
- (void)setAttributes:(NSDictionary *)attributes forObject:(PFObject *)object;
- (void)setAttributesForObject:(PFObject *)object likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser;

- (BOOL)isObjectLikedByCurrentUser:(PFObject *)object;
- (void)setObjectIsLikedByCurrentUser:(PFObject *)object liked:(BOOL)liked;

- (NSNumber *)likeCountForObject:(PFObject *)object;
- (void)incrementLikeCountForObject:(PFObject *)object;
- (void)decrementLikeCountForObject:(PFObject *)object;

- (NSNumber *)commentCountForObject:(PFObject *)object;
- (void)incrementCommentCountForObject:(PFObject *)object;
- (void)decrementCommentCountForObject:(PFObject *)object;

@end
