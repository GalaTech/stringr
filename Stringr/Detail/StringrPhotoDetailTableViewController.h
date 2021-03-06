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

typedef enum : NSUInteger {
    ScrolledLeft = 0,
    ScrolledRight = 1
} ScrollDirection;

@interface StringrPhotoDetailTableViewController : StringrDetailTableViewController <QMBParallaxScrollViewHolder>

@property (strong, nonatomic) PFObject *photoDetailsToLoad;
@property (strong, nonatomic) PFObject *stringOwner;

@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *photoDescription;

- (void)reloadPhotoDetailsWithScrollDirection:(ScrollDirection)direction;

@end
