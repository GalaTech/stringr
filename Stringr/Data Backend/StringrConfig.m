//
//  StringrConfig.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrConfig.h"
#import "StringrAppDelegate.h"
#import "STGRAppViewController.h"

static NSString * StringrFirstRunKey = @"kStringrCompletedFirstRunKey";
static NSString * StringrDebugEnabledKey = @"kStringrDebugEnabledKey";

@interface StringrConfig () <UIAlertViewDelegate>

@end

@implementation StringrConfig

#pragma mark - Lifecycle

+ (StringrConfig *)sharedConfig
{
    static dispatch_once_t onceToken;
    static StringrConfig *sharedConfig;
    dispatch_once(&onceToken, ^{
        sharedConfig = [StringrConfig new];
    });
    
    return sharedConfig;
}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupFirstLaunch];
    }
    
    return self;
}


- (void)setupFirstLaunch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:StringrFirstRunKey] == nil) {
        [defaults setObject:@(YES) forKey:StringrFirstRunKey];
        [defaults setBool:NO forKey:StringrDebugEnabledKey];
    }
    else {
        [defaults setObject:@(NO) forKey:StringrFirstRunKey];
    }
}


- (BOOL)isFirstLaunch
{
    return [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:StringrFirstRunKey] boolValue];
}


#pragma mark - Debug

- (BOOL)isDebugMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:StringrDebugEnabledKey];
}


- (void)setDebugMode:(BOOL)debugMode
{
    BOOL currentMode = [self isDebugMode];
    
    if (currentMode != debugMode) {
        NSString *alertMessage = @"The app will now close. On relaunch %@ mode will be used.";
        
        alertMessage = [NSString stringWithFormat:alertMessage, (currentMode) ? @"PRODUCTION" : @"DEBUG"];
        
        UIAlertView *debugToggleAlert = [[UIAlertView alloc] initWithTitle:@"Toggle Debug" message:alertMessage delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        
        [debugToggleAlert show];
    }
}


- (void)intentionalCrashToCompleteConfigToggle
{
    exit(1);
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL debugEnabled = [defaults boolForKey:StringrDebugEnabledKey];
        [defaults setBool:!debugEnabled forKey:StringrDebugEnabledKey];
        [defaults synchronize];
        
        [[UIApplication appDelegate].appViewController logout];
        
        [self intentionalCrashToCompleteConfigToggle];
    }
}


@end
