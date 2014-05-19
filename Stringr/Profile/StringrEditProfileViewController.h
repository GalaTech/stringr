//
//  StringrEditProfileViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;

@protocol StringrEditProfileDelegate;

@interface StringrEditProfileViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) StringrPathImageView *fillerProfileImage;
@property (strong, nonatomic) NSString *fillerProfileName;
@property (strong, nonatomic) NSString *fillerDescription;
@property (strong, nonatomic) NSString *fillerUniversityName;

@property (weak, nonatomic) id<StringrEditProfileDelegate> delegate;

@end


@protocol StringrEditProfileDelegate <NSObject>

@optional
- (void)setProfileName:(NSString *)name;
- (void)setProfilePhoto:(UIImage *)profilePhoto;
- (void)setProfileDescription:(NSString *)description;

@end



