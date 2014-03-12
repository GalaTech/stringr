//
//  StringrProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "QMBParallaxScrollViewController.h"

typedef enum{
    ProfileModalReturnState = 0,
    ProfileMenuReturnState = 1,
    ProfileBackReturnState = 2
} ProfileReturnState;

/**
 * Initialize's a user profile as a parallax view controller. The top half is a users information and 
 * the bottom is a tableView of their String's. You must provide a user for the profile in order for it to work
 * as well as a profileReturnState. The return state refers to how the profile is being displayed: From the menu, 
 * as a modal presentation, or just pushed onto a nav controller. The return state provides information on what return
 * navigation item will be displayed. 
 */
@interface StringrProfileViewController : QMBParallaxScrollViewController<QMBParallaxScrollViewControllerDelegate>

@property (strong, nonatomic) PFUser *userForProfile;
@property (assign, nonatomic) ProfileReturnState profileReturnState;

@end
