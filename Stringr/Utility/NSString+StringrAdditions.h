//
//  NSString+StringrAdditions.h
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringrAdditions)

- (BOOL)NSStringIsValidUsername;
- (BOOL)NSStringIsValidEmail;
- (BOOL)NSStringContainsCharactersWithoutWhiteSpace;

- (NSString *)stringTrimmedForLeadingAndTrailingWhiteSpacesFromString;
- (NSString *)usernameFormattedWithMentionSymbol;

+ (NSString *)randomStringWithLength:(int)length;

@end
