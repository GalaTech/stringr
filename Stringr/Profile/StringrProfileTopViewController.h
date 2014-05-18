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

@property (strong, nonatomic) PFUser *userForProfile;

@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@property (weak, nonatomic) IBOutlet StringrPathImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileUniversityLabel;

@property (nonatomic) BOOL isFollowingUser;


@end
