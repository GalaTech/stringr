//
//  StringrEditProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrPathImageView.h"


@protocol StringrEditProfileDelegate <NSObject>

@optional
- (void)setProfileName:(NSString *)name;
- (void)setProfilePhoto:(UIImage *)profilePhoto;
- (void)setProfileDescription:(NSString *)description;
- (void)setProfileUniversityName:(NSString *)universityName;


@end


@interface StringrEditProfileViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) StringrPathImageView *fillerProfileImage;
@property (strong, nonatomic) NSString *fillerProfileName;
@property (strong, nonatomic) NSString *fillerDescription;
@property (strong, nonatomic) NSString *fillerUniversityName;

@property (strong, nonatomic) id<StringrEditProfileDelegate> delegate;

@end



