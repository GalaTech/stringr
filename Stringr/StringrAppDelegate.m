//
//  AppDelegate.m
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrAppDelegate.h"
#import "StringrAppController.h"
#import "StringrNavigationController.h"
#import "StringrStringTableViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrStringTableViewController.h"
#import "StringrMenuViewController.h"
#import "StringrFollowingTableViewController.h"
#import "Reachability.h"
#import "StringrPopularTableViewController.h"
#import "StringrDiscoveryTableViewController.h"
#import "StringrNearYouTableViewController.h"
#import "StringrNetworkTask+Activity.h"
#import "StringrUpdateEngine.h"

#import "StringrNetworkTask.h"
#import "StringrObject.h"

#import "TestTableViewController.h"

@interface StringrAppDelegate ()

@end

@implementation StringrAppDelegate

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Registers the app for notification types via in app alert view
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
//    [application registerForRemoteNotifications];
    
    // setup and initialize the login controller
    self.rootViewController = (StringrAppController *)[self.window rootViewController];
    [self.rootViewController launchSequence:launchOptions];
    
//    [self testLaunchSequence];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    // add blank channel key initially
    [currentInstallation addUniqueObject:@"" forKey:kStringrInstallationPrivateChannelsKey];
    
    if ([PFUser currentUser]) {
        // see if we have a private channel key already associated with the current user
        // if we do set the current installation's channel to that of the current user.
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey];
        if (privateChannelName && privateChannelName.length > 0) {
            [currentInstallation addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
        }
        
    }
    // Store the deviceToken in the current installation and save it to Parse.
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveEventually];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
}


// Parse will display an in app alert view with the notification text if the user has
// the app open when a notifcation is sent
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
        NSString *alert = userInfo[@"aps"][@"alert"];
        
        if ([alert rangeOfString:@"is now following you"].location != NSNotFound) {
            [PFPush handlePush:userInfo];
        }
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        [self setupLoggedInContent];
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    // sets the app badge icon to 0
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] setBadge:0];
        [[PFInstallation currentInstallation] saveEventually];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [PFQuery clearAllCachedResults];
    [[StringrCache sharedCache] clear];
    
    [[StringrUpdateEngine sharedEngine] stop];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[StringrUpdateEngine sharedEngine] start];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)setupLoggedInContent
{
    StringrMenuViewController *menuVC = (StringrMenuViewController *)self.rootViewController.menuViewController;
    // Forces the menu table view controller to be scrolled to the top upon logging in
    menuVC.tableView.contentOffset = CGPointMake(0, 0 - menuVC.tableView.contentInset.top);
    
    [self.rootViewController setContentViewController:[StringrHomeTabBarViewController new]];
    [[StringrUpdateEngine sharedEngine] start];
}


#pragma mark - Private

- (void)testLaunchSequence
{
    TestTableViewController *testVC = [TestTableViewController new];
    
    self.window.rootViewController = testVC;
    
    [self.window makeKeyAndVisible];
}


@end
