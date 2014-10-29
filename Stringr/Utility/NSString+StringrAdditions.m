//
//  NSString+StringrAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "NSString+StringrAdditions.h"
#import "UIDevice+StringrAdditions.h"

@implementation NSString (StringrAdditions)

- (BOOL)isValidUsername
{
    if ([self containsCharactersWithoutWhiteSpace] && self.length > 0 && self.length <= 15) {
        // This string dictates what characters are valid to use for creating a username.
        // This uses some set expressions and regular expression operators. http://userguide.icu-project.org/strings/regexp
        NSString *validCharacters = @"[A-Z0-9a-z._-]+?";
        NSPredicate *validCharactersTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validCharactersTest evaluateWithObject:self];
    }
    
    return NO;
}


- (BOOL)isValidEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}


- (BOOL)containsCharactersWithoutWhiteSpace
{
    NSCharacterSet *noCharacters = [NSCharacterSet whitespaceCharacterSet];
    NSArray *textWords = [self componentsSeparatedByCharactersInSet:noCharacters];
    NSString *textWithoutWhiteSpace = [textWords componentsJoinedByString:@""];
    
    if (textWithoutWhiteSpace.length > 0) {
        return YES;
    }
    
    return NO;
}


- (NSString *)trimLeadingAndTrailingWhiteSpace
{
    NSString *leadingTrailingWhiteSpacesPattern = @"(?:^\\s+)|(?:\\s+$)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:leadingTrailingWhiteSpacesPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSRange stringRange = NSMakeRange(0, self.length);
    NSString *trimmedString = [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:stringRange withTemplate:@"$1"];
    
    return trimmedString;
}


- (NSString *)usernameFormattedWithMentionSymbol
{
    return [NSString stringWithFormat:@"@%@", self];
}


- (NSString *)formattedWithDecimalPlaceValue
{
    NSNumber *stringValue = @([self integerValue]);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [numberFormatter stringFromNumber:stringValue];
}


+ (NSString *)randomStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex: arc4random() % letters.length]];
    }
    
    return randomString;
}

@end
