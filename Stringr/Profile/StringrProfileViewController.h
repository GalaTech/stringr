//
//  StringrProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

typedef enum{
    ProfileModalReturnState = 1,
    ProfileMenuReturnState = 2,
    ProfileBackReturnState = 3
} ProfileReturnState;

@interface StringrProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *userForProfile;
@property (nonatomic) BOOL isDashboardProfile;

@property (nonatomic) ProfileReturnState profileReturnState;

+ (StringrProfileViewController *)viewController;

@end
