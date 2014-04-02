//
//  StringrLoginViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@protocol StringrLoginViewDownloadingSocialNetworkInfoDelegate;

@interface StringrLoginViewController : UIViewController

@property (strong, nonatomic) id<StringrLoginViewDownloadingSocialNetworkInfoDelegate>delegate;

@end


@protocol StringrLoginViewDownloadingSocialNetworkInfoDelegate <NSObject>

- (void)socialNetworkProfileImageDidFinishDownloading:(UIImage *)profileImage;

@end