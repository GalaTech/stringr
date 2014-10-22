//
//  TestTableViewHeader.h
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;

@interface TestTableViewHeader : UITableViewHeaderFooterView

- (void)configureHeaderWithString:(PFObject *)string;

@end
