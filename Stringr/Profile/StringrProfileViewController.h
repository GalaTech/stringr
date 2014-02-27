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

@interface StringrProfileViewController : QMBParallaxScrollViewController<QMBParallaxScrollViewControllerDelegate>

@property (strong, nonatomic) PFUser *userForProfile;

@property (nonatomic) BOOL canCloseModal;
@property (nonatomic) BOOL canEditProfile;

@end
