//
//  NSString+StringrAdditions.h
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringrAdditions)

- (BOOL)isValidUsername;
- (BOOL)isValidEmail;
- (BOOL)containsCharactersWithoutWhiteSpace;

- (NSString *)trimLeadingAndTrailingWhiteSpace;
- (NSString *)usernameFormattedWithMentionSymbol;
- (NSString *)formattedWithDecimalPlaceValue;
+ (NSString *)formattedFromInteger:(NSUInteger)value;

+ (NSString *)stringWithUsernameFormat:(NSString *)username;
+ (NSString *)stringWithHashtagFormat:(NSString *)tag;

+ (NSString *)randomStringWithLength:(NSInteger)length;

@end
