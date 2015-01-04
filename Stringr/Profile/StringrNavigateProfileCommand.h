//
//  StringrNavigateProfileCommand.h
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNavigateCommand.h"

@protocol StringrContainerScrollViewDelegate;

typedef enum {
    ProfileCommandUserStrings = 0,
    ProfileCommandLikedStrings,
    ProfileCommandLikedPhotos,
    ProfileCommandPublicPhotos
} ProfileCommandType;

@interface StringrNavigateProfileCommand : StringrNavigateCommand

@property (nonatomic) ProfileCommandType commandType;
@property (strong, nonatomic) UIViewController <StringrContainerScrollViewDelegate>*viewController;
@property (strong, nonatomic) PFUser *user;

@end
