//
//  StringrRootViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrAppController.h"
#import "StringrLoginViewController.h"
#import "StringrNavigationController.h"
#import "StringrDiscoveryTabBarViewController.h"
#import "StringrStringTableViewController.h"
#import "StringrHomeTabBarViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrUpdateEngine.h"
#import "UIFont+StringrFonts.h"

#import "Reachability.h"

@interface StringrAppController ()

@property (strong, nonatomic) NSDictionary *launchOptions;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic) int networkStatus;

@end

@implementation StringrAppController

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        UIViewController *backgroundVC = [[UIViewController alloc] init];
        
        UIImage *fillerImage = [UIImage imageNamed:@"pre_logged_in_filler"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        backgroundImageView.image = fillerImage;
        [backgroundVC.view addSubview:backgroundImageView];
        
        self.contentViewController = backgroundVC;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardMenuID];
}


- (void)dealloc
{
    
}


- (void)launchSequence:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    [self setupParse];
    [self setupLoginController];
    [self monitorReachability];
    [self setupAppearance];
}


#pragma mark - Parse Setup

- (void)setupParse
{
    [Parse setApplicationId:@"m0bUE5DhNMVo4IWlcCr5G2089J1doTDj3jGgXlzu" clientKey:@"8bfs0C7Z9kySt6uWNMYcZZIN4c6GzUZUh2pdFlxK"];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"6gI4gef1b48PR9KYoZ58hQ" consumerSecret:@"BFlTa5t2XrGF8Ez0kGPLbuaOFZwcPh5FxjCinJas"];
    
    // Parse 'app open' analytics®
    [PFAnalytics trackAppOpenedWithLaunchOptions:self.launchOptions];
}


#pragma mark - Private

- (void)setupAppearance
{
    self.liveBlur = YES;
    
    // makes the menu thinner than the default
    self.menuViewSize = CGSizeMake(250, CGRectGetHeight(self.view.frame));
    
    // Sets the navigation bar title to a lighter font variant throughout the app.
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                                            NSFontAttributeName: [UIFont stringrPrimaryLabelFontWithSize:18.0f]
                                                            }];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}


- (void)setupLoginController
{
    StringrLoginViewController *loginVC = [StringrLoginViewController viewController];
    [loginVC setDelegate:self];
    [loginVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    UINavigationController *loginNavVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    // Slightly delays the presentation of the loginVC so that it doesn't mess up the navigation
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self presentViewController:loginNavVC animated:YES completion:nil];
    });
}


- (void)setupPushChannel:(PFUser *)user
{
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


#pragma mark - Reachability

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


// Called by Reachability whenever status changes.
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


- (BOOL)isParseReachable
{
    BOOL isParseReachable = self.networkStatus != NotReachable;
    
    if (!isParseReachable) {
        UIAlertView *checkInternetConnectionAlertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect with the server. Check your internet connection and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [checkInternetConnectionAlertView show];
    }
    
    return isParseReachable;
}


#pragma mark - StringrLoginViewControllerDelegate

- (void)logInViewController:(StringrLoginViewController *)logInController didLogInUser:(PFUser *)user
{
    [self setupPushChannel:user];
}

@end
