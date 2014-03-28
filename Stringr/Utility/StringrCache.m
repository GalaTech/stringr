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







@end
