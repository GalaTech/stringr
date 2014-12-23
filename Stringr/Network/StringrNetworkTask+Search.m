//
//  StringrNetworkTask+Search.m
//  Stringr
//
//  Created by Jonathan Howard on 12/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Search.h"

@implementation StringrNetworkTask (Search)

+ (void)searchForUser:(NSString *)searchText completion:(void (^)(NSArray *users, NSError *error))completion
{
    if (searchText && [StringrUtility NSStringContainsCharactersWithoutWhiteSpace:searchText]) {
        
        NSString *modifiedSearchText = [StringrUtility stringTrimmedForLeadingAndTrailingWhiteSpacesFromString:searchText];
        
        //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(username BEGINSWITH[c]%@) OR (displayNameCaseInsensitive BEGINSWITH[c]%@)", lowercaseSearchText, lowercaseSearchText];
        //PFQuery * userQuery = [PFQuery queryWithClassName:@"_User" predicate:predicate];
        
        // Forces search to look at the beginning pattern of words so that it's not matching letters in the center
        // of a word. Also looks at the end of word to match for last names.
        //NSString *usernameSearchRegexPattern = [NSString stringWithFormat:@"^%@|%@$", modifiedSearchText, modifiedSearchText];
        
        // I check for username case sensitive on both just to make sure the user is completed in sign-up. This will be corrected.
        PFQuery *userUsernameQuery = [PFUser query];
        [userUsernameQuery whereKey:kStringrUserUsernameKey matchesRegex:modifiedSearchText modifiers:@"i"];
        [userUsernameQuery whereKeyExists:kStringrUserUsernameCaseSensitive];
        
        PFQuery *userDisplaynameQuery = [PFUser query];
        [userDisplaynameQuery whereKey:kStringrUserDisplayNameKey matchesRegex:modifiedSearchText modifiers:@"i"];
        [userDisplaynameQuery whereKeyExists:kStringrUserUsernameCaseSensitive];
        
        PFQuery *userQuery = [PFQuery orQueryWithSubqueries:@[userUsernameQuery, userDisplaynameQuery]];
        [userQuery orderByAscending:kStringrUserUsernameKey];
        
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (completion) {
                completion(objects, error);
            }
        }];
    }
}

@end
