//
//  StringrProfileTopViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 12/2/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPathImageView.h"
#import "ACPButton.h"

@interface StringrProfileTopViewController : UIViewController

@property (weak, nonatomic) IBOutlet GBPathImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
//@property (weak, nonatomic) IBOutlet UITextView *profileDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileUniversityLabel;

@property (weak, nonatomic) IBOutlet ACPButton *followUserButton;
@property (nonatomic) BOOL isFollowingUser;

- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight;

@end
