//
//  StringrPhoto.m
//  Stringr
//
//  Created by Jonathan Howard on 8/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhoto.h"

@implementation StringrPhoto

#pragma mark - Lifecycle

- (instancetype)initWithObject:(PFObject *)object
{
    self = [super init];
    
    if (self) {
        _parsePhoto = object;
    }
    
    return self;
}


+ (instancetype)photoWithObject:(PFObject *)object
{
    return [[StringrPhoto alloc] initWithObject:object];
}


#pragma mark - Accessors (Getter)

- (NSString *)title
{
    return self.parsePhoto[kStringrPhotoCaptionKey];
}


- (PFUser *)uploader
{
    return self.parsePhoto[kStringrPhotoUserKey];
}


- (NSInteger)photoOrder
{
    return [self.parsePhoto[kStringrPhotoOrderNumber] integerValue];
}


- (CGFloat)width
{
    return [self.parsePhoto[kStringrPhotoPictureWidth] floatValue];
}


- (CGFloat)height
{
    return [self.parsePhoto[kStringrPhotoPictureHeight] floatValue];
}


#pragma mark - Public

+ (NSArray *)photosFromArray:(NSArray *)array
{
    NSMutableArray *photosArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (id object in array) {
        if ([object isKindOfClass:[PFObject class]]) {
            StringrPhoto *photo = [StringrPhoto photoWithObject:object];
            
            if (photo) [photosArray addObject:photo];
        }
    }
    
    return [photosArray copy];
}


- (void)loadImageInBackground:(void (^)(UIImage *image, NSError *error))completion;
{
    PFFile *imageFile = [self.parsePhoto objectForKey:kStringrPhotoPictureKey];
    
    __weak typeof(self) weakSelf = self;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photoImage = [UIImage imageWithData:data];
            weakSelf.image = photoImage;
            
            if (completion) {
                completion(photoImage, error);
            }
        }
    }];
}

#pragma mark - <StringrObject>

- (NSString *)parseClassName
{
    return self.parsePhoto.parseClassName;
}


- (NSString *)objectID
{
    return self.parsePhoto.objectId;
}


- (NSDate *)updatedAt
{
    return self.parsePhoto.updatedAt;
}


- (NSDate *)createdAt
{
    return self.parsePhoto.createdAt;
}

@end
