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

@interface StringrAppController ()

@end

@implementation StringrAppController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

/*
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        UIViewController *backgroundVC = [[UIViewController alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *fillerImage = [UIImage imageNamed:@"pre_logged_in_filler"];
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:fillerImage];
            [backgroundVC.view addSubview:backgroundImageView];
        });
        
        self.contentViewController = backgroundVC;
        self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardMenuID];
        
        self.liveBlur = YES;
        // makes the menu thinner than the default
        self.menuViewSize = CGSizeMake(250, CGRectGetHeight(self.view.frame));
        
        // Sets the navigation bar title to a lighter font variant throughout the app.
        [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                                NSForegroundColorAttributeName: [UIColor grayColor],
                                                                NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f]
                                                                }];
    }
    
    return self;
}
*/

- (void)awakeFromNib
{
    UIViewController *backgroundVC = [[UIViewController alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *fillerImage = [UIImage imageNamed:@"pre_logged_in_filler"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:fillerImage];
        [backgroundVC.view addSubview:backgroundImageView];
    });
    
    self.contentViewController = backgroundVC;
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardMenuID];
    
    self.liveBlur = YES;
    // makes the menu thinner than the default
    self.menuViewSize = CGSizeMake(250, CGRectGetHeight(self.view.frame));
    
    // Sets the navigation bar title to a lighter font variant throughout the app.
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f]
                                                            }];
}

- (void)dealloc
{
    NSLog(@"dealloc root view");
}


@end
