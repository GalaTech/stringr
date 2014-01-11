//
//  StringrProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "M6ParallaxController.h"

@interface StringrProfileViewController : M6ParallaxController<UIGestureRecognizerDelegate>

@property (nonatomic) BOOL canGoBack;
@property (nonatomic) BOOL canCloseModal;
@property (nonatomic) BOOL canEditProfile;

@end
