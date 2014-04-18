//
//  StringViewReorderable.h
//  Stringr
//
//  Created by Jonathan Howard on 2/2/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringView.h"

@interface StringViewReorderable : StringView

/**
 * Removes the given photo from the String.
 * @param photo The photo that you are wanting to remove from the string.
 */
- (void)removePhotoFromString:(PFObject *)photo;

- (void)setStringTitle:(NSString *)stringTitle;
- (void)setStringDescription:(NSString *)stringDescription;
- (void)setStringWriteAccess:(BOOL)isPublic;

- (void)saveAndPublishInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock;

- (void)cancelString;

- (void)deleteString;

@end
