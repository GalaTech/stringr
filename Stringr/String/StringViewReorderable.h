//
//  StringViewReorderable.h
//  Stringr
//
//  Created by Jonathan Howard on 2/2/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringView.h"


@interface StringViewReorderable : StringView

/** Adds a given photo to the end of the String.
 *
 * @param photo The photo being added to the String.
 */
- (void)addPhotoToString:(NSDictionary *)photo;


/** Removes a photo from the String at a given index.
 *
 * @param index The index number of the photo that you're wantint to remove.
 * All photos in the string are in 1 section. This only refers to the item number.
 */
- (void)removePhotoFromStringAtIndex:(NSInteger)index;

/** Removes the given photo from the String.
 *
 * @param photo The photo that you are wanting to remove from the string.
 */
- (void)removePhotoFromString:(NSDictionary *)photo;

@end
