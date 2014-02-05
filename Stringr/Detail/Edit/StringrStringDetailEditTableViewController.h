//
//  StringrStringDetailEditTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTableViewController.h"

@protocol StringrStringDetailEditViewControllerDelegate <NSObject>

/**
 * Inserts the user selected photo into a currently displayed string.
 *
 * @param image The photo that the user selected to add to the string.
 */
- (void)addedNewImageToString:(UIImage *)image;

@end

@interface StringrStringDetailEditTableViewController : StringrStringDetailTableViewController

@property (strong, nonatomic) id<StringrStringDetailEditViewControllerDelegate> delegate;

@end
