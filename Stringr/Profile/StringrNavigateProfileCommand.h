//
//  StringrNavigateProfileCommand.h
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateCommand.h"

@protocol StringrContainerScrollViewDelegate;

@interface StringrNavigateProfileCommand : StringrNavigateCommand

@property (strong, nonatomic) UIViewController <StringrContainerScrollViewDelegate>*viewController;
@property (strong, nonatomic) PFUser *user;

@end
