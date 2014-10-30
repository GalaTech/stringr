//
//  StringrCache.m
//  Stringr
//
//  Created by Jonathan Howard on 3/27/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrCache.h"

@interface StringrCache ()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation StringrCache

#pragma mark - Lifecycle

+ (instancetype)sharedCache
{
    static StringrCache *sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}

- (void)clear
{
    [self.cache removeAllObjects];
}



#pragma mark - Get User Attributes

- (NSString *)keyForUser:(PFUser *)user
{
    return [NSString stringWithFormat:@"user_%@", user.objectId];
}

- (NSDictionary *)attributesForUser:(PFUser *)user
{
    NSString *userKey = [self keyForUser:user];
    return [self.cache objectForKey:userKey];
}

- (BOOL)followStatusForUser:(PFUser *)user
{
    NSDictionary *userAttributes = [self attributesForUser:user];
    if (userAttributes) {
        NSNumber *followStatus = [userAttributes objectForKey:kStringrUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (NSNumber *)stringCountForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *stringCount = [attributes objectForKey:kStringrUserAttributesStringCountKey];
        if (stringCount) {
            return stringCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)followingCountForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followingCount = [attributes objectForKey:kStringrUserAttributesFollowingCountKey];
        if (followingCount) {
            return followingCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}


- (NSNumber *)followerCountForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followerCount = [attributes objectForKey:kStringrUserAttributesFollowerCountKey];
        if (followerCount) {
            return followerCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}



#pragma mark - Set User Attributes

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user
{
    NSString *userKey = [self keyForUser:user];
    [self.cache setObject:attributes forKey:userKey];
}

- (void)setAttributesForUser:(PFUser *)user stringCount:(NSNumber *)count followedByCurrentUser:(BOOL)followed
{
    NSDictionary *userAttributes = [NSDictionary dictionaryWithObjectsAndKeys:count, kStringrUserAttributesStringCountKey,
                                    [NSNumber numberWithBool:followed], kStringrUserAttributesIsFollowedByCurrentUserKey, nil];
    
    [self setAttributes:userAttributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following forUser:(PFUser *)user
{
    NSMutableDictionary *userAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [userAttributes setObject:[NSNumber numberWithBool:following] forKey:kStringrUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:userAttributes forUser:user];
}

- (void)setStringCount:(NSNumber *)count forUser:(PFUser *)user
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kStringrUserAttributesStringCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowingCount:(NSNumber *)count forUser:(PFUser *)user
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kStringrUserAttributesFollowingCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowerCount:(NSNumber *)count forUser:(PFUser *)user
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kStringrUserAttributesFollowerCountKey];
    [self setAttributes:attributes forUser:user];
}



#pragma mark - Set Object Attributes

- (void)setAttributes:(NSDictionary *)attributes forObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        [self setAttributes:attributes forString:object];
    } else {
        [self setAttributes:attributes forPhoto:object];
    }
}

- (void)setAttributesForObject:(PFObject *)object likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser
{
    if ([StringrUtility objectIsString:object]) {
        [self setAttributesForString:object likeCount:likeCount commentCount:commentCount likedByCurrentUser:likedByCurrentUser];
    } else {
        [self setAttributesForPhoto:object likeCount:likeCount commentCount:commentCount likedByCurrentUser:likedByCurrentUser];
    }
}

- (void)setObjectIsLikedByCurrentUser:(PFObject *)object liked:(BOOL)liked
{
    if ([StringrUtility objectIsString:object]) {
        [self setStringIsLikedByCurrentUser:object liked:liked];
    } else {
        [self setPhotoIsLikedByCurrentUser:object liked:liked];
    }
}

- (void)incrementLikeCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        [self incrementLikeCountForString:object];
    } else {
        [self incrementLikeCountForPhoto:object];
    }
}

- (void)decrementLikeCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        [self decrementLikeCountForString:object];
    } else {
        [self decrementLikeCountForPhoto:object];
    }
}

- (void)incrementCommentCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        [self incrementCommentCountForString:object];
    } else {
        [self incrementCommentCountForPhoto:object];
    }
}

- (void)decrementCommentCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        [self decrementCommentCountForString:object];
    } else {
        [self decrementCommentCountForPhoto:object];
    }
}



#pragma mark - Get Object Attributes

- (NSDictionary *)attributesForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        return [self attributesForString:object];
    } else {
        return [self attributesForPhoto:object];
    }
}

- (BOOL)isObjectLikedByCurrentUser:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        return [self isStringLikedByCurrentUser:object];
    } else {
        return [self isPhotoLikedByCurrentUser:object];
    }
}

- (NSNumber *)likeCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        return [self likeCountForString:object];
    } else {
        return [self likeCountForPhoto:object];
    }
}

- (NSNumber *)commentCountForObject:(PFObject *)object
{
    if ([StringrUtility objectIsString:object]) {
        return [self commentCountForString:object];
    } else {
        return [self commentCountForPhoto:object];
    }
}



#pragma mark - Get Photo Attributes

- (NSString *)keyForPhoto:(PFObject *)photo
{
    return [NSString stringWithFormat:@"photo_%@", photo.objectId];
}

- (NSDictionary *)attributesForPhoto:(PFObject *)photo
{
    NSString *photoKey = [self keyForPhoto:photo];
    return [self.cache objectForKey:photoKey];
}

- (NSNumber *)likeCountForPhoto:(PFObject *)photo
{
    NSDictionary *photoAttributes = [self attributesForPhoto:photo];
    
    if (photoAttributes) {
        return [photoAttributes objectForKey:kStringrPhotoAttributesLikeCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPhoto:(PFObject *)photo
{
    NSDictionary *photoAttributes = [self attributesForPhoto:photo];
    
    if (photoAttributes) {
        return [photoAttributes objectForKey:kStringrPhotoAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo
{
    NSDictionary *photoAttributes = [self attributesForPhoto:photo];
    
    if (photoAttributes) {
        return [[photoAttributes objectForKey:kStringrPhotoAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}



#pragma mark - Set Photo Attributes

- (void)setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo
{
    NSString *photoKey = [self keyForPhoto:photo];
    [self.cache setObject:attributes forKey:photoKey];
}

- (void)setAttributesForPhoto:(PFObject *)photo likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser
{
    NSDictionary *photoAttributes = [NSDictionary dictionaryWithObjectsAndKeys:likeCount, kStringrPhotoAttributesLikeCountKey,
                                     commentCount, kStringrPhotoAttributesCommentCountKey,
                                     [NSNumber numberWithBool:likedByCurrentUser], kStringrPhotoAttributesIsLikedByCurrentUserKey, nil];
    
    [self setAttributes:photoAttributes forPhoto:photo];
}

- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked
{
    NSMutableDictionary *photoAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [photoAttributes setObject:[NSNumber numberWithBool:liked] forKey:kStringrPhotoAttributesIsLikedByCurrentUserKey];
    [self setAttributes:photoAttributes forPhoto:photo];
}

- (void)incrementLikeCountForPhoto:(PFObject *)photo
{
    NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *photoAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [photoAttributes setObject:likeCount forKey:kStringrPhotoAttributesLikeCountKey];
    [self setAttributes:photoAttributes forPhoto:photo];
}

- (void)decrementLikeCountForPhoto:(PFObject *)photo
{
    NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] - 1];
    if ([likeCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *photoAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [photoAttributes setObject:likeCount forKey:kStringrPhotoAttributesLikeCountKey];
    [self setAttributes:photoAttributes forPhoto:photo];
}

- (void)incrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *photoAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [photoAttributes setObject:commentCount forKey:kStringrPhotoAttributesCommentCountKey];
    [self setAttributes:photoAttributes forPhoto:photo];
}

- (void)decrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *photoAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [photoAttributes setObject:commentCount forKey:kStringrPhotoAttributesCommentCountKey];
    [self setAttributes:photoAttributes forPhoto:photo];
}



#pragma mark - Get String Attributes

- (NSString *)keyForString:(PFObject *)string
{
    return [NSString stringWithFormat:@"string_%@", string.objectId];
}

- (NSDictionary *)attributesForString:(PFObject *)string
{
    NSString *stringKey = [self keyForString:string];
    return [self.cache objectForKey:stringKey];
}

- (NSNumber *)likeCountForString:(PFObject *)string
{
    NSDictionary *stringAttributes = [self attributesForString:string];
    
    if (stringAttributes) {
        return [stringAttributes objectForKey:kStringrStringAttributesLikeCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForString:(PFObject *)string
{
    NSDictionary *stringAttributes = [self attributesForString:string];
    
    if (stringAttributes) {
        return [stringAttributes objectForKey:kStringrStringAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)isStringLikedByCurrentUser:(PFObject *)string
{
    NSDictionary *stringAttributes = [self attributesForString:string];
    
    if (stringAttributes) {
        return [[stringAttributes objectForKey:kStringrStringAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}



#pragma mark - Set String Attributes

- (void)setAttributes:(NSDictionary *)attributes forString:(PFObject *)string
{
    NSString *stringKey = [self keyForString:string];
    [self.cache setObject:attributes forKey:stringKey];
}

- (void)setAttributesForString:(PFObject *)string likeCount:(NSNumber *)likeCount commentCount:(NSNumber *)commentCount likedByCurrentUser:(BOOL)likedByCurrentUser
{
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:likeCount, kStringrStringAttributesLikeCountKey,
                                      commentCount, kStringrStringAttributesCommentCountKey,
                                      [NSNumber numberWithBool:likedByCurrentUser], kStringrStringAttributesIsLikedByCurrentUserKey, nil];
    
    [self setAttributes:stringAttributes forString:string];
}

- (void)setStringIsLikedByCurrentUser:(PFObject *)string liked:(BOOL)liked
{
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForString:string]];
    [stringAttributes setObject:[NSNumber numberWithBool:liked] forKey:kStringrStringAttributesIsLikedByCurrentUserKey];
    [self setAttributes:stringAttributes forString:string];
}

- (void)incrementLikeCountForString:(PFObject *)string
{
    NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForString:string] intValue] + 1];
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForString:string]];
    [stringAttributes setObject:likeCount forKey:kStringrStringAttributesLikeCountKey];
    [self setAttributes:stringAttributes forString:string];
}

- (void)decrementLikeCountForString:(PFObject *)string
{
    NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForString:string] intValue] - 1];
    if ([likeCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForString:string]];
    [stringAttributes setObject:likeCount forKey:kStringrStringAttributesLikeCountKey];
    [self setAttributes:stringAttributes forString:string];
}

- (void)incrementCommentCountForString:(PFObject *)string
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForString:string] intValue] + 1];
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForString:string]];
    [stringAttributes setObject:commentCount forKey:kStringrStringAttributesCommentCountKey];
    [self setAttributes:stringAttributes forString:string];
}

- (void)decrementCommentCountForString:(PFObject *)string
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForString:string] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForString:string]];
    [stringAttributes setObject:commentCount forKey:kStringrStringAttributesCommentCountKey];
    [self setAttributes:stringAttributes forString:string];
}





@end
