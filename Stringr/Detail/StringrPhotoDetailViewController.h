//
//  StringrPhotoDetailViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailViewController.h"
#import "QMBParallaxScrollViewController.h"

@interface StringrPhotoDetailViewController : StringrDetailViewController

@property (strong, nonatomic) NSArray *stringImages;
@property (strong, nonatomic) UIImage *currentImage;

@property (strong, nonatomic) NSArray *photosToLoad;
@property (nonatomic) NSUInteger selectedPhotoIndex;
@property (strong, nonatomic) PFObject *stringOwner;

@end
