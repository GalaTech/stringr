//
//  StringrString.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"

@interface StringrString : StringrObject

@property (strong, nonatomic) PFObject *string;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) PFUser *uploader;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *uploadDate;
@property (copy, nonatomic) NSString *updatedDate;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSArray *likers;

@end
