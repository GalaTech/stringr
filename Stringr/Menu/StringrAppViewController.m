//
//  StringrRootViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrAppViewController.h"
#import "StringrLaunchViewController.h"
#import "StringrLoginViewController.h"
#import "StringrNavigationController.h"
#import "StringrDashboardTabBarController.h"
#import <ParseCrashReporting/ParseCrashReporting.h>
#import "StringrUpdateEngine.h"
#import "UIFont+StringrFonts.h"
#import "NSLayoutConstraint+StringrAdditions.h"

#import "StringrAuthenticationManager.h"
#import "Reachability.h"

@interface StringrAppViewController () <StringrLoginViewControllerDelegate>

@property (strong, nonatomic, readwrite) UIViewController *currentContentViewController;
@property (strong, nonatomic) IBOutlet UIView *contentContainerView;

@property (strong, nonatomic) NSDictionary *launchOptions;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic) int networkStatus;

@end

@implementation StringrAppViewController

#pragma mark - Lifecycle

+ (StringrAppViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StringrAppControllerStoryboard" bundle:nil];
    
    return (StringrAppViewController *)[storyboard instantiateInitialViewController];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {

    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInitialLaunchControllers];
}


- (void)launchSequence:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    [self firstRun];
    [self setupParse];
    [self monitorReachability];
    [self setupAppearance];
}


- (void)setupInitialLaunchControllers
{
    StringrLaunchViewController *launchVC = [StringrLaunchViewController new];
    [self setContentViewController:launchVC animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transitionToLoginViewController:YES];
    });
}


#pragma mark - Public

- (void)signup
{
    [self transitionToDashboardViewController:YES];
    
    NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [[PFUser currentUser] objectId]];
    [[PFUser currentUser] setObject:privateChannelName forKey:kStringrUserPrivateChannelKey];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            [[PFUser currentUser] setObject:geoPoint forKey:@"geoLocation"];
            
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kStringrInstallationUserKey];
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
            [[PFInstallation currentInstallation] saveEventually];
        }
        
        [[PFUser currentUser] saveInBackground];
    }];
}


- (void)logout
{
    [StringrAuthenticationManager logoutCurrentUser];
    [[StringrUpdateEngine sharedEngine] stop];
    [self transitionToLoginViewController:YES];
}


#pragma mark - Private

- (void)setupAppearance
{
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                                            NSFontAttributeName: [UIFont stringrPrimaryLabelFontWithSize:18.0f]
                                                            }];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
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


- (BOOL)firstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"kStringrCompletedFirstRunKey"]) {
        [defaults setBool:YES forKey:@"kStringrCompletedFirstRunKey"];
        [defaults setBool:NO forKey:@"kStringrDebugEnabledKey"];
        
        return YES;
    }
    
    return NO;
}


#pragma mark - Navigation Transformations

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated
{
    if (self.currentContentViewController != contentViewController) {
        UIViewController *previousViewController = self.currentContentViewController;
        
        self.currentContentViewController = contentViewController;
        
        [self transitionFromContentViewController:previousViewController toContentViewController:self.currentContentViewController animated:animated];
    }
}


- (void)transitionFromContentViewController:(UIViewController *)fromViewController toContentViewController:(UIViewController *)toViewController
{
    if (fromViewController) {
        [fromViewController willMoveToParentViewController:nil];
        [fromViewController beginAppearanceTransition:NO animated:NO];
        [fromViewController.view removeFromSuperview];
        [fromViewController endAppearanceTransition];
        [fromViewController removeFromParentViewController];
        [fromViewController didMoveToParentViewController:nil];
    }
    
    [toViewController beginAppearanceTransition:YES animated:YES];
    [self embedChildViewController:toViewController containerView:self.contentContainerView];
    [toViewController endAppearanceTransition];
}


- (void)transitionFromContentViewController:(UIViewController *)fromViewController toContentViewController:(UIViewController *)toViewController animated:(BOOL)animated
{
    if (animated) {
        toViewController.view.alpha = 0.0f;
        
        [fromViewController willMoveToParentViewController:nil];
        [fromViewController beginAppearanceTransition:NO animated:NO];
        
        [toViewController beginAppearanceTransition:YES animated:YES];
        
        [self embedChildViewController:toViewController containerView:self.contentContainerView];
        
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.alpha = 1.0f;
            fromViewController.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [toViewController endAppearanceTransition];
            if (fromViewController) {
                [fromViewController.view removeFromSuperview];
                [fromViewController endAppearanceTransition];
                [fromViewController removeFromParentViewController];
                [fromViewController didMoveToParentViewController:nil];
            }
        }];
    } else {
        [self transitionFromContentViewController:fromViewController toContentViewController:toViewController];
    }
}


- (void)embedChildViewController:(UIViewController *)viewController containerView:(UIView *)containerView
{
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addConstraints:[NSLayoutConstraint constraintsToFillSuperviewWithView:viewController.view]];
}


#pragma mark - Public Navigation Transitions

- (void)transitionToLoginViewController:(BOOL)animated
{
    StringrLoginViewController *loginVC = [StringrLoginViewController viewController];
    [loginVC setDelegate:self];
    UINavigationController *loginNavVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    [self setContentViewController:loginNavVC animated:animated];
}


- (void)transitionToDashboardViewController:(BOOL)animated
{
    StringrDashboardTabBarController *dashboardViewController = [StringrDashboardTabBarController new];
    [self setContentViewController:dashboardViewController animated:animated];
}


- (void)transitionToDashboardTabIndex:(DashboardTabIndex)index
{
    if ([self.currentContentViewController isKindOfClass:[StringrDashboardTabBarController class]]) {
        [(StringrDashboardTabBarController *)self.currentContentViewController setDashboardTabIndex:index];
    }
}


- (void)transitionToStringCreator:(BOOL)animated
{
    
}


#pragma mark - Parse Setup

- (void)setupParse
{
    [ParseCrashReporting enable];
    
    BOOL debugEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"kStringrDebugEnabledKey"];

    if (debugEnabled) {
        [Parse setApplicationId:kStringrParseDebugApplicationID clientKey:kStringrParseDebugClientKey];
    }
    else {
        [Parse setApplicationId:kStringrParseApplicationID clientKey:kStringrParseClientKey];
    }
    
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"6gI4gef1b48PR9KYoZ58hQ" consumerSecret:@"BFlTa5t2XrGF8Ez0kGPLbuaOFZwcPh5FxjCinJas"];
    
    // Parse 'app open' analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:self.launchOptions];
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
    [self transitionToDashboardViewController:YES];
    
    [[StringrUpdateEngine sharedEngine] start];
    
    [self setupPushChannel:user];
}

@end
