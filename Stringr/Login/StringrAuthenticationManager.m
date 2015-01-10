//
//  StringrAuthenticationManager.m
//  Stringr
//
//  Created by Jonathan Howard on 1/9/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrAuthenticationManager.h"

@implementation StringrAuthenticationManager

+ (void)logoutCurrentUser
{
    [PFQuery clearAllCachedResults];
    [[StringrCache sharedCache] clear];
    
    // Unsubscribe from push notifications for this installation
    [[PFInstallation currentInstallation] removeObjectForKey:kStringrInstallationUserKey];
    
    PFObject *currentUserPrivateChannelKey = [[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey];
    
    if (currentUserPrivateChannelKey) {
        [[PFInstallation currentInstallation] removeObject:currentUserPrivateChannelKey forKey:kStringrInstallationPrivateChannelsKey];
    }
    
    [[PFInstallation currentInstallation] saveEventually];
    
    [PFUser logOut];
}

@end
