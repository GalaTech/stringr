//
//  StringrPhotoDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailViewController.h"
#import "StringrPhotoTopDetailViewController.h"
#import "StringrPhotoDetailTableViewController.h"
#import "StringrStringEditViewController.h"
#import "StringrStringCommentsViewController.h"
#import "StringrProfileViewController.h"

@interface StringrPhotoDetailViewController () <UIScrollViewDelegate, QMBParallaxScrollViewControllerDelegate>

@end

@implementation StringrPhotoDetailViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photo";
    
    if (self.isPhotoEditable) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePhoto)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhotoEdit)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushToStringDetailPage)];
    }

    
    StringrPhotoTopDetailViewController *topPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"topPhotoVC"];
    StringrPhotoDetailTableViewController *tablePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tablePhotoVC"];
    self.delegate = self;
    
    [self setupWithTopViewController:topPhotoVC andTopHeight:300 andBottomViewController:tablePhotoVC];
    
    
    [self enableTapGestureTopView:YES];
    [self setMaxHeight:CGRectGetHeight(self.view.frame)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    StringrPhotoTopDetailViewController *topPhotoVC = (StringrPhotoTopDetailViewController *)self.topViewController;
    [topPhotoVC.photoImage setImage:self.currentImage];
    
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




#pragma mark - NSNotificationCenter Handlers

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
    [profileVC setTitle:@"User Profile"];
    //[profileVC setCanCloseModal:YES];
    
    [profileVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:profileVC animated:YES];
    
    //Implements modal transition to profile view
    //StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    //[self presentViewController:navVC animated:YES completion:nil];
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




#pragma mark - Action
                                              
- (void)pushToStringDetailPage
{
    StringrStringEditViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
    [self.navigationController pushViewController:stringDetailVC animated:YES];
}

- (void)savePhoto
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelPhotoEdit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - ParallaxController Delegate

- (void) parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state
{
    [self.navigationController setNavigationBarHidden:self.state == QMBParallaxStateFullSize animated:YES];
}


@end
