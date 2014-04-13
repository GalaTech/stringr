//
//  StringrStringTopEditViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrDetailTopViewController.h"
#import "StringView.h"

@interface StringrStringDetailTopViewController : StringrDetailTopViewController <StringViewDelegate>

//@property (strong, nonatomic) NSArray *stringPhotoData;
@property (strong, nonatomic) PFObject *stringToLoad;


@end
