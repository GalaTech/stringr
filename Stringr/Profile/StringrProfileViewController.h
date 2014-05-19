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

@interface StringrProfileViewController : QMBParallaxScrollViewController<QMBParallaxScrollViewControllerDelegate>

@property (strong, nonatomic) PFUser *userForProfile;
@property (nonatomic) ProfileReturnState profileReturnState;

@end
