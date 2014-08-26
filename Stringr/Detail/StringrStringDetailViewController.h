//
//  StringrStringEditViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailViewController.h"
#import "QMBParallaxScrollViewController.h"

@interface StringrStringDetailViewController : StringrDetailViewController

@property (strong, nonatomic) PFObject *stringToLoad;
@property (strong, nonatomic) UIImage *userSelectedPhoto; // from UIImagePickerView
@property (strong, nonatomic) NSArray *userSelectedPhotos; // from Multi-Selected Image Picker

@end
