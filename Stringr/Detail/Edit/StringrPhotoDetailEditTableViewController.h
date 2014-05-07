//
//  StringrPhotoDetailEditTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTableViewController.h"

/*
@protocol StringrPhotoDetailViewControllerDelegate <NSObject>

** Sends a call to delete the given photo from the targeted String.
 *
 * @param photo The photo that will be removed from the targeted String.
 *
- (void)deletePhotoFromString:(NSDictionary *)photo;

@end
*/
@protocol StringrPhotoDetailEditTableViewControllerDelegate;
@interface StringrPhotoDetailEditTableViewController : StringrPhotoDetailTableViewController

@property (strong, nonatomic) id<StringrPhotoDetailEditTableViewControllerDelegate> delegate;

@end

@protocol StringrPhotoDetailEditTableViewControllerDelegate <NSObject>

@optional
- (void)deletePhotoFromString:(PFObject *)photo;
- (void)deletePhotoFromPublicString:(PFObject *)photo;

@end