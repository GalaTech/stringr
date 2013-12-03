//
//  StringrEditProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPathImageView.h"


@protocol StringrEditProfileDelegate <NSObject>

@optional
- (void)setProfileName:(NSString *)name;
- (void)setProfilePicture:(UIImageView *)profilePicture;
- (void)setProfileDescription:(NSString *)description;


@end


@interface StringrEditProfileViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) GBPathImageView *fillerProfileImage;
@property (strong, nonatomic) NSString *fillerProfileName;
@property (strong, nonatomic) NSString *fillerDescription;

@property (strong, nonatomic) id<StringrEditProfileDelegate> delegate;

@end



