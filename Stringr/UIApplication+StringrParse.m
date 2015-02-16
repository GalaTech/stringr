//
//  UIApplication+StringrParse.m
//  Stringr
//
//  Created by Jonathan Howard on 2/12/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "UIApplication+StringrParse.h"
#import <ParseCrashReporting/ParseCrashReporting.h>
#import "StringrConfig.h"

@implementation UIApplication (StringrParse)

- (void)setupParse
{
    [ParseCrashReporting enable];
    
    BOOL debugEnabled = [StringrConfig sharedConfig].isDebugMode;
    
    if (debugEnabled) {
        [Parse setApplicationId:kStringrParseDebugApplicationID clientKey:kStringrParseDebugClientKey];
    }
    else {
        [Parse setApplicationId:kStringrParseApplicationID clientKey:kStringrParseClientKey];
    }
    
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"6gI4gef1b48PR9KYoZ58hQ" consumerSecret:@"BFlTa5t2XrGF8Ez0kGPLbuaOFZwcPh5FxjCinJas"];
    
    // Parse 'app open' analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
}

@end
