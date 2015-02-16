//
//  StringrPhoto.h
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrObject.h"

@class StringrString;

@interface StringrPhoto : NSObject <StringrObject>

@property (strong, nonatomic) PFObject *parsePhoto;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) PFUser *uploader;
@property (strong, nonatomic) StringrString *stringOwner;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) NSInteger photoOrder;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (instancetype)initWithObject:(PFObject *)object;
- (instancetype)init __attribute__ ((unavailable("[-init] is not allowed, use [-initWithObject:]")));

+ (instancetype)photoWithObject:(PFObject *)object;
+ (instancetype)new __attribute__ ((unavailable("[+new] is not allowed, use [+stringWithObject:]")));

+ (NSArray *)photosFromArray:(NSArray *)array;

- (void)loadImageInBackground:(void (^)(UIImage *image, NSError *error))completion;

@end
