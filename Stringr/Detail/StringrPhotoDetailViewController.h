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
#import "StringrPhotoDetailEditTableViewController.h"

@interface StringrPhotoDetailViewController : StringrDetailViewController

/// An array of photo objects that will be displayed in the photo pager.
@property (strong, nonatomic) NSArray *photosToLoad;

/// The index of the photo that was tapped by the user. This index is what sets the initial photo that is shown.
@property (nonatomic) NSUInteger selectedPhotoIndex;

/**
 * The string owner for the current set of photos. The string owner will be the same
 * for all photos if you are viewing a standard string.
 * The string owner might be different for every photo for liked photos.
 * This property should be nil if you are instantiating a photo detail view for 
 * a set of liked photos.
 */
@property (strong, nonatomic) PFObject *stringOwner;

@property (nonatomic) BOOL isPublicPhoto;

@property (weak, nonatomic) id<StringrPhotoDetailEditTableViewControllerDelegate> delegateForPhotoController;

@end
