//
//  AppDelegate.m
//  Stringr
//
//  Created by Jonathan Howard on 11/5/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "StringrRootViewController.h"
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


@interface AppDelegate ()

@property (weak, nonatomic) StringrRootViewController *rootVC;
@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic) int networkStatus;

@end

@implementation AppDelegate

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize app for Parse and Facebook
    [Parse setApplicationId:@"m0bUE5DhNMVo4IWlcCr5G2089J1doTDj3jGgXlzu" clientKey:@"8bfs0C7Z9kySt6uWNMYcZZIN4c6GzUZUh2pdFlxK"];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"6gI4gef1b48PR9KYoZ58hQ" consumerSecret:@"BFlTa5t2XrGF8Ez0kGPLbuaOFZwcPh5FxjCinJas"];
    
    // Parse 'app open' analytics®
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Registers the app for notification types via in app alert view
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self monitorReachability];

    // setup and initialize the login controller
    self.rootVC = (StringrRootViewController *)[self.window rootViewController];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    StringrLoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardLoginID];
    [loginVC setDelegate:self];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    UINavigationController *loginNavVC = [[UINavigationController alloc]initWithRootViewController:loginVC];

    // Slightly delays the presentation of the loginVC so that it doesn't mess up the navigation
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.rootVC presentViewController:loginNavVC animated:YES completion:nil];
    });
    
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
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([PFUser currentUser]) {
        if ([self.tabBarController viewControllers].count > PAPActivityTabBarItemIndex) {
            UITabBarItem *tabBarItem = [[[self.tabBarController viewControllers] objectAtIndex:PAPActivityTabBarItemIndex] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
            
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
            } else {
                tabBarItem.badgeValue = @"1";
            }
        }
    }
     */
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    /*
    if ([PFUser currentUser]) {
        
    }
     */
    
    
    [PFPush handlePush:userInfo];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    StringrMenuViewController *menuVC = (StringrMenuViewController *)self.rootVC.menuViewController;
    // Forces the menu table view controller to be scrolled to the top upon logging in
    menuVC.tableView.contentOffset = CGPointMake(0, 0 - menuVC.tableView.contentInset.top);
    
    [self.rootVC setContentViewController:[self setupHomeTabBarController]];
}

- (BOOL)isParseReachable
{
    BOOL isParseReachable = self.networkStatus != NotReachable;
    
    if (!isParseReachable) {
        UIAlertView *checkInternetConnectionAlertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect with the server. Check your internet connection and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [checkInternetConnectionAlertView show];
    }
    
    return isParseReachable;
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (void)monitorReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note
{
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    self.networkStatus = [curReach currentReachabilityStatus];
    
    /*
    if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
        [self.homeViewController loadObjects];
    }
     */
}

- (StringrHomeTabBarViewController *)setupHomeTabBarController
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    StringrHomeTabBarViewController *homeTabBarVC = [[StringrHomeTabBarViewController alloc] init];
    
    StringrFollowingTableViewController *followingVC = [[StringrFollowingTableViewController alloc] initWithStyle:UITableViewStylePlain];
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    
    StringrActivityTableViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardActivityTableID];
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activity_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    // Checks to see if there are any new activity notifications to display as a badge icon on the activity tab
    PFQuery *activityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery whereKeyExists:kStringrActivityFromUserKey];
    [activityQuery includeKey:kStringrActivityFromUserKey];
    [activityQuery includeKey:kStringrActivityStringKey];
    [activityQuery includeKey:kStringrActivityPhotoKey];
    [activityQuery countObjectsInBackgroundWithBlock:^(int numberOfActivites, NSError *error) {
        if (!error) {
            NSNumber *numberOfPreviousActivitiesFromInstallation = [[PFUser currentUser] objectForKey:kStringrInstallationNumberOfPreviousActivitiesKey];
           
            NSInteger numberOfPreviousActivities = 0;
            if (numberOfPreviousActivitiesFromInstallation) {
                numberOfPreviousActivities = [numberOfPreviousActivitiesFromInstallation integerValue];
            }
            
            NSInteger numberOfNewActivities = numberOfActivites - numberOfPreviousActivities;
            
            if (numberOfNewActivities > 0) {
                [activityTab setBadgeValue:[NSString stringWithFormat:@"%d", numberOfNewActivities]];
            }
            
            [[PFUser currentUser] setObject:@(numberOfActivites) forKey:kStringrInstallationNumberOfPreviousActivitiesKey];
            [[PFUser currentUser] saveInBackground];
        }
    }];
    
    [homeTabBarVC setViewControllers:@[followingNavVC, activityNavVC]];
    
    return homeTabBarVC;
}

- (StringrDiscoveryTabBarViewController *)setupDiscoveryTabBarController
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [[StringrDiscoveryTabBarViewController alloc] init];
    
    StringrPopularTableViewController *popularVC = [[StringrPopularTableViewController alloc] initWithStyle:UITableViewStylePlain];
    StringrNavigationController *popularNavVC = [[StringrNavigationController alloc] initWithRootViewController:popularVC];
    UITabBarItem *popularTab = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"crown_icon"] tag:0];
    [popularNavVC setTabBarItem:popularTab];
    
    StringrDiscoveryTableViewController *discoverVC = [[StringrDiscoveryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    StringrNavigationController *discoverNavVC = [[StringrNavigationController alloc] initWithRootViewController:discoverVC];
    UITabBarItem *discoverTab = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [discoverNavVC setTabBarItem:discoverTab];
    
    StringrNearYouTableViewController *nearYouVC = [[StringrNearYouTableViewController alloc] initWithStyle:UITableViewStylePlain];
    StringrNavigationController *nearYouNavVC = [[StringrNavigationController alloc] initWithRootViewController:nearYouVC];
    UITabBarItem *nearYouTab = [[UITabBarItem alloc] initWithTitle:@"Near You" image:[UIImage imageNamed:@"solarSystem_icon"] tag:0];
    [nearYouNavVC setTabBarItem:nearYouTab];
    
    [discoveryTabBarVC setViewControllers:@[popularNavVC, discoverNavVC, nearYouNavVC]];
    
    return discoveryTabBarVC;
}



//*********************************************************************************/
#pragma mark - StringrLoginViewControllerDelegate
//*********************************************************************************/

- (void)logInViewController:(StringrLoginViewController *)logInController didLogInUser:(PFUser *)user
{
    //[self setupLoggedInContent];
    
    // Subscribe to private push channel
    if (user) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // checks for push enabled key first. If it exists we setup their channel based upon their preferences
        // else we set it up regardless.
        if ([defaults objectForKey:kNSUserDefaultsPushNotificationsEnabledKey]) {
            BOOL pushEnabled = [defaults boolForKey:kNSUserDefaultsPushNotificationsEnabledKey];
            if (pushEnabled) {
                // Creates a unique channel name based off the users objectID and saves it to both the user and current installation
                NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kStringrInstallationUserKey];
                [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
                [[PFInstallation currentInstallation] saveEventually];
            } else {
                [[PFInstallation currentInstallation] removeObjectForKey:kStringrInstallationUserKey];
                [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey] forKey:kStringrInstallationPrivateChannelsKey];
                [[PFInstallation currentInstallation] saveEventually];
            }
        } else {
            // Creates a unique channel name based off the users objectID and saves it to both the user and current installation
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kStringrInstallationUserKey];
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
            [[PFInstallation currentInstallation] saveEventually];
            [user setObject:privateChannelName forKey:kStringrUserPrivateChannelKey];
            [user saveEventually];
        }
    }
}



@end
