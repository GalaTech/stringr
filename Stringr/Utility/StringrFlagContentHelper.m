//
//  StringrFlagContentHelper.m
//  Stringr
//
//  Created by Jonathan Howard on 8/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFlagContentHelper.h"

@implementation StringrFlagContentHelper

+ (void)flagContent:(PFObject *)content withFlaggingUser:(PFUser *)user
{
    [self flagContent:content withFlaggingUser:user completionHandler:nil];
}

+ (void)flagContent:(PFObject *)content withFlaggingUser:(PFUser *)user completionHandler:(void (^)(BOOL success, NSError *))completionHandler
{
    NSString *flaggedContentType = kStringrFlaggedPhotoKey;
    if ([StringrUtility objectIsString:content]) {
        flaggedContentType = kStringrFlaggedStringKey;
    }
    
    PFQuery *flaggedContentQuery = [PFQuery queryWithClassName:kStringrFlaggedContentClassKey];
    [flaggedContentQuery whereKey:flaggedContentType equalTo:content];
    [flaggedContentQuery whereKey:kstringrFlaggingUserKey equalTo:user];
    [flaggedContentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            PFObject *flaggedContent = [PFObject objectWithClassName:kStringrFlaggedContentClassKey];
            [flaggedContent setObject:content forKey:flaggedContentType];
            [flaggedContent setObject:[content objectForKey:kStringrPhotoUserKey] forKey:kStringrFlaggedUserKey];
            [flaggedContent setObject:[PFUser currentUser] forKey:kstringrFlaggingUserKey];
            [flaggedContent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (completionHandler) {
                    completionHandler(succeeded, error);
                }
            }];
        }
    }];
}

@end
