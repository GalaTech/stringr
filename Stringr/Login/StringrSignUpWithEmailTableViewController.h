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
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *password;

@end
