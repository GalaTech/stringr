//
//  StringrSignUpWithEmailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 3/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrSignUpWithEmailTableViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImage *userProfileImage;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *displayName;
@property (copy, nonatomic) NSString *emailAddress;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *reenteredPassword;

@end
