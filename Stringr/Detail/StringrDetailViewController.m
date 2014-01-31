//
//  StringrDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/29/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"
#import "StringrNavigationController.h"

@interface StringrDetailViewController () <QMBParallaxScrollViewControllerDelegate>

@end

@implementation StringrDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegate:self];
    
    [self.view setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfileImage:) name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCommentsButton:) name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectLikesButton:) name:@"didSelectLikesButton" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
}




#pragma mark - NSNotificationCenter Actions

// Handles the action of pushing to a selected user's profile
- (void)didSelectProfileImage:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
    NSLog(@"Removed observers from selecting profile");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
    
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    [profileVC setCanGoBack:YES];
    [profileVC setCanEditProfile:NO];
    [profileVC setTitle:@"Profile"];
    [profileVC setCanCloseModal:YES];
    
    //[profileVC setHidesBottomBarWhenPushed:YES];
    //[self.navigationController pushViewController:profileVC animated:YES];
    
    //Implements modal transition to profile view
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

// Handles the action of pushing to the comment's of a selected string
- (void)didSelectCommentsButton:(NSNotification *)notification
{
    StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringCommentsVC"];
    
    [self.navigationController pushViewController:commentsVC animated:YES];
}

// Handles the action of liking the selected string
- (void)didSelectLikesButton:(NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked String"
                                                    message:@"You have liked this String!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}



@end
