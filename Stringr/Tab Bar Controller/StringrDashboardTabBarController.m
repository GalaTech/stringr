//
//  StringrHomeTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDashboardTabBarController.h"
#import "StringrActivityTableViewController.h"
#import "StringrNetworkTask+Activity.h"

#import "StringrNavigationController.h"
#import "StringrFollowingTableViewController.h"

#import "StringrProfileViewController.h"
#import "StringrExploreViewController.h"

#import "StringrActivityManager.h"
#import "UIColor+StringrColors.h"
#import "UIImage+StringrImageAdditions.h"

#import "StringrColorGenerator.h"

@interface StringrDashboardTabBarController ()

@property (strong, nonatomic) StringrColorGenerator *colorGenerator;

@property (strong, nonatomic) UIButton *cameraButton;

@end

@implementation StringrDashboardTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDashboardViewControllers];
    [self setupAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActivityNotificationsTabValue) name:@"currentUserHasNewActivities" object:nil];
}


#pragma mark - Private

- (void)setupDashboardViewControllers
{
    StringrFollowingTableViewController *followingVC = [StringrFollowingTableViewController new];
    StringrNavigationController *followingNavVC = [[StringrNavigationController alloc] initWithRootViewController:followingVC];
    followingNavVC.navigationBar.translucent = NO;
    UITabBarItem *followingTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"rabbit_icon"] tag:0];
    [followingNavVC setTabBarItem:followingTab];
    
    StringrExploreViewController *exploreVC = [StringrExploreViewController viewController];
    StringrNavigationController *exploreNavVC = [[StringrNavigationController alloc] initWithRootViewController:exploreVC];
    exploreNavVC.navigationBar.translucent = NO;
    UITabBarItem *exploreTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"sailboat_icon"] tag:0];
    [exploreVC setTabBarItem:exploreTab];
    
    UIViewController *cameraVC = [UIViewController new];
    UITabBarItem *cameraTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"camera_button"] tag:0];
    [cameraVC setTabBarItem:cameraTab];
    
    StringrActivityTableViewController *activityVC = [StringrActivityTableViewController viewController];
    StringrNavigationController *activityNavVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    activityNavVC.navigationBar.translucent = NO;
    UITabBarItem *activityTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"activity_icon"] tag:0];
    [activityNavVC setTabBarItem:activityTab];
    
    StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
    profileVC.userForProfile = [PFUser currentUser];
    profileVC.isDashboardProfile = YES;
    StringrNavigationController *profileNavVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    profileNavVC.navigationBar.tintColor = [UIColor whiteColor];
    profileNavVC.navigationBar.translucent = NO;
    UITabBarItem *profileTab = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"users_icon"] tag:0];
    [profileVC setTabBarItem:profileTab];
    
    [self setViewControllers:@[followingNavVC, exploreNavVC, cameraVC, activityNavVC, profileNavVC]];
}


- (void)setupAppearance
{
    [self.tabBar setTintColor:[UIColor grayColor]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        item.image = [[item.selectedImage tintedImageUsingColor:[UIColor stringrTabBarItemColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [self addCenterButtonWithImage:nil highlightImage:nil];
}


-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.cameraButton.frame = CGRectMake(0.0, 0.0, 54, 54);
    [self.cameraButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    self.cameraButton.backgroundColor = [UIColor whiteColor];
    
    [self.cameraButton setImage:[UIImage imageNamed:@"StringrCameraPlusIcon"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraTabSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton addTarget:self action:@selector(cameraTabPushedDown:) forControlEvents:UIControlEventTouchDown];
    [self.cameraButton addTarget:self action:@selector(cameraButtonTocuhedUpOutside:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragOutside];
    
    self.cameraButton.layer.cornerRadius = 27;
    self.cameraButton.layer.borderWidth = 1.0f;
    
    self.colorGenerator = [StringrColorGenerator generatorWithDefaultStringrColors];
    self.cameraButton.layer.borderColor = [self.colorGenerator nextRandomColor].CGColor;
    [self performSelector:@selector(changeCameraButtonColor) withObject:nil afterDelay:10.0f];
    
    CGFloat heightDifference = 54 - self.tabBar.frame.size.height;
    if (heightDifference == 0)
        self.cameraButton.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference / 2;
        self.cameraButton.center = center;
    }
    
    [self.view addSubview:self.cameraButton];
}


#pragma mark - IBActions

- (IBAction)cameraTabSelected:(UIButton *)sender
{
    [self setDashboardTabIndex:DashboardCameraIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.cameraButton.backgroundColor = [UIColor whiteColor];
    }];
}


- (IBAction)cameraTabPushedDown:(UIButton *)sender
{
    self.cameraButton.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0f];
}


- (IBAction)cameraButtonTocuhedUpOutside:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.cameraButton.backgroundColor = [UIColor whiteColor];
    }];
}


#pragma mark - Public

- (void)setDashboardTabIndex:(DashboardTabIndex)index
{
    [self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[index]];
    [self setSelectedIndex:index];
}


- (UIViewController *)currentlySelectedDashboardViewController
{
    return self.viewControllers[self.selectedIndex];
}


#pragma mark - Private

- (void)changeCameraButtonColor
{
    UIColor *fromColor = [UIColor colorWithCGColor:self.cameraButton.layer.borderColor];
    UIColor *toColor = [self.colorGenerator nextRandomColor];
    
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.duration = 1.5f;
    borderColorAnimation.fromValue = (id)fromColor.CGColor;
    borderColorAnimation.toValue   = (id)toColor.CGColor;
    self.cameraButton.layer.borderColor = toColor.CGColor;
    
    [self.cameraButton.layer addAnimation:borderColorAnimation forKey:@"color"];
    
    [self performSelector:@selector(changeCameraButtonColor) withObject:nil afterDelay:10.0f];
}


- (void)updateActivityNotificationsTabValue
{
    NSInteger numberOfNewActivities = [[StringrActivityManager sharedManager] numberOfNewActivitiesForCurrentUser];
    
    if (numberOfNewActivities > 0) {
        UITabBarItem *activityTab = self.tabBar.items[DashboardActivityIndex];
        
        [activityTab setBadgeValue:[NSString stringWithFormat:@"%ld", (long)numberOfNewActivities]];
    }
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.selectedIndex == DashboardActivityIndex) {
        item.badgeValue = nil;
    }
}


@end
