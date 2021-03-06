//
//  StringrLoginViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrViewController.h"

@protocol StringrLoginViewControllerDelegate;

@interface StringrLoginViewController : UIViewController <StringrViewController>

@property (weak, nonatomic) id<StringrLoginViewControllerDelegate>delegate;

@end


@protocol StringrLoginViewControllerDelegate <NSObject>

@optional
- (void)logInViewController:(StringrLoginViewController *)logInController didLogInUser:(PFUser *)user;
- (void)socialNetworkProfileImageDidFinishDownloading:(UIImage *)profileImage;

@end