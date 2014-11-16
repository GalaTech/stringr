//
//  StringrProfileTopViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;

@interface StringrProfileTopViewController : UIViewController

@property (weak, nonatomic) IBOutlet StringrPathImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;

@property (strong, nonatomic) PFUser *userForProfile;
@property (nonatomic) BOOL isFollowingUser;

@end
