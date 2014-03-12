//
//  StringrPhotoDetailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTableViewController.h"
#import "QMBParallaxScrollViewController.h"

@interface StringrPhotoDetailTableViewController : StringrDetailTableViewController <QMBParallaxScrollViewHolder>

@property (strong, nonatomic) PFObject *photoDetailsToLoad;
@property (strong, nonatomic) PFObject *stringOwner;

@end
