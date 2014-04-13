//
//  StringrStringDetailTopEditViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTopViewController.h"
#import "StringrStringDetailTopViewController.h"
#import "StringrStringDetailEditTableViewController.h"

@interface StringrStringDetailEditTopViewController : StringrStringDetailTopViewController <StringrStringDetailEditTableViewControllerDelegate>

@property (strong, nonatomic) UIImage *userSelectedPhoto; // from UIImagePickerView

/**
 * Inserts the user selected photo into the currently displayed string.
 * @param image The photo that the user selected to add to the string.
 */
- (void)addNewImageToString:(UIImage *)image;

/**
 * Saves the current string to the server and publishes it.
 * All data set for the string and all of the contained photos
 * will be saved.
 */
- (void)saveString;

- (void)cancelString;

@end
