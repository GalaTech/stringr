//
//  AppDelegate.m
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "StringrRootViewController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrNavigationController.h"
#import "StringrLoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize app for Parse and Facebook
    [Parse setApplicationId:@"m0bUE5DhNMVo4IWlcCr5G2089J1doTDj3jGgXlzu" clientKey:@"8bfs0C7Z9kySt6uWNMYcZZIN4c6GzUZUh2pdFlxK"];
    [PFFacebookUtils initializeFacebook];
    
    // Parse 'app open' analytics®
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    StringrRootViewController *rootVC = (StringrRootViewController *)[self.window rootViewController];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    StringrLoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    //[self.window makeKeyAndVisible];
    
    // makes it so that the login screen only appears if you need to login, but results in double check to see if user is authenticated
    //if (![PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        // Slightly delays the presentation of the loginVC so that it doesn't mess up the navigation
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [rootVC presentViewController:loginVC animated:YES completion:nil];
        });
    //}
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
