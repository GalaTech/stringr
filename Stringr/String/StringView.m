//
//  StringCellView.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"
#import "StringCollectionView.h"
#import "UIImage+Decompression.h"

#import <QuartzCore/QuartzCore.h>

@interface StringView ()

@property (weak, nonatomic) IBOutlet StringCollectionView *stringCollectionView;
@property (weak, nonatomic) IBOutlet StringCollectionView *stringLargeCollectionView;

@end

@implementation StringView

#pragma mark - Lifecycle

/*
- (void)awakeFromNib
{
    // Register the colleciton cell for both large and normal string sizes
    [_stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
    // Large is only utilized on the detail string pages
    [_stringLargeCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];    
}

- (void)dealloc
{
    self.collectionViewPhotos = nil;
    self.stringPhotosToDelete = nil;
    [PFQuery clearAllCachedResults];
    self.stringCollectionView = nil;
    self.stringLargeCollectionView = nil;
    NSLog(@"dealloc string");
}
*/



#pragma mark - Custom Accessors

/*
- (void)setCollectionData:(NSMutableArray *)collectionData {
    _collectionData = collectionData;
}
 */

/*
- (void)setStringObject:(PFObject *)string
{
    if (string) {
        _stringToLoad = string;
        
        // queries parse after a string object has been set to load
        [self queryPhotosFromString];
    }
}
 

- (NSMutableArray *)collectionViewPhotos
{
    if (!_collectionViewPhotos) {
        _collectionViewPhotos = [[NSMutableArray alloc] init];
    }
    
    return _collectionViewPhotos;
}


- (NSMutableArray *)stringPhotosToDelete
{
    if (!_stringPhotosToDelete) {
        _stringPhotosToDelete = [[NSMutableArray alloc] init];
    }
    
    return _stringPhotosToDelete;
}




#pragma mark - Public

// Add image to public string
- (void)addImageToString:(UIImage *)image withBlock:(void (^)(BOOL succeeded, PFObject *photo, NSError *error))completionBlock
{
    if (image) {
        PFObject *photo = [PFObject objectWithClassName:kStringrPhotoClassKey];
        
        UIImage *resizedImage = [StringrUtility formatPhotoImageForUpload:image];
        NSData *resizedImageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
        
        PFFile *imageFileForUpload = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpeg", [StringrUtility randomStringWithLength:8]] data:resizedImageData];
        [imageFileForUpload saveInBackground];
        
        [photo setObject:imageFileForUpload forKey:kStringrPhotoPictureKey];
        [photo setObject:[PFUser currentUser] forKey:kStringrPhotoUserKey];
        
        NSNumber *width = [NSNumber numberWithInt:resizedImage.size.width];
        NSNumber *height = [NSNumber numberWithInt:resizedImage.size.height];
        
        [photo setObject:width forKey:kStringrPhotoPictureWidth];
        [photo setObject:height forKey:kStringrPhotoPictureHeight];
        
        [photo setObject:@"" forKey:kStringrPhotoCaptionKey];
        [photo setObject:@"" forKey:kStringrPhotoDescriptionKey];
        [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
        [photo setObject:@(self.collectionViewPhotos.count) forKey:kStringrPhotoOrderNumber];
        
        PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [photoACL setWriteAccess:YES forUser:[self.stringToLoad objectForKey:kStringrStringUserKey]]; // sets write access for the user uploading the photo
        [photoACL setPublicReadAccess:YES];
        [photo setACL:photoACL];
        
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                int indexOfImagePhoto = [self.collectionViewPhotos indexOfObject:resizedImage];
                [self.collectionViewPhotos replaceObjectAtIndex:indexOfImagePhoto withObject:photo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionViewPhotos count] - 1 inSection:0];
                if (self.stringCollectionView) {
                    [self.stringCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else if (self.stringLargeCollectionView) {
                    [self.stringLargeCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
            
            if (completionBlock) {
                completionBlock(succeeded, photo, error);
            }
        }];
        
        [self.collectionViewPhotos addObject:resizedImage];
        
        // if the collectionViewPhotos count == 1 that means we just added the first object.
        // That means this must be a brand new string.
        // For every other situation it must mean that we are adding a new photo to a string.
        if (self.collectionViewPhotos.count == 1) {
            if (self.stringCollectionView) {
                [self.stringCollectionView reloadData];
            } else if (self.stringLargeCollectionView) {
                [self.stringLargeCollectionView reloadData];
            }
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.collectionViewPhotos.count - 1 inSection:0];
            if (self.stringCollectionView) {
                [self.stringCollectionView insertItemsAtIndexPaths:@[indexPath]];
                [self.stringCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            } else if (self.stringLargeCollectionView) {
                [self.stringLargeCollectionView insertItemsAtIndexPaths:@[indexPath]];
                [self.stringLargeCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }     
    }
}

- (void)removePhotoFromString:(PFObject *)photo
{
    if (photo) {
        NSUInteger indexOfPhoto = [self.collectionViewPhotos indexOfObject:photo];
        
        PFObject *photo = [self.collectionViewPhotos objectAtIndex:indexOfPhoto];
        [photo deleteEventually];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfPhoto inSection:0];
        [self.collectionViewPhotos removeObjectAtIndex:indexOfPhoto];
        
        if (self.stringCollectionView) {
            [self.stringCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        } else if (self.stringLargeCollectionView) {
            [self.stringLargeCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
}

- (void)reloadString
{
    if (self.stringCollectionView) {
        [self.stringCollectionView reloadData];
    } else if (self.stringLargeCollectionView) {
        [self.stringLargeCollectionView reloadData];
    }
}




#pragma mark - Private

- (void)deletePhotoFromString:(PFObject *)photo
{
    
}




#pragma mark - Parse

- (void)queryPhotosFromString
{
    if (self.stringToLoad) {
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:self.stringToLoad];
        [stringPhotoQuery orderByAscending:@"photoOrder"]; // photoOrder: each photo has a number associated with where it falls into the string
        [stringPhotoQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if (!error) {
                self.collectionViewPhotos = [[NSMutableArray alloc] initWithArray:photos];
                
                if (self.stringCollectionView) {
                    [self.stringCollectionView reloadData];
                } else if (self.stringLargeCollectionView) {
                    [self.stringLargeCollectionView reloadData];
                }
            }
        }];
    }
}

- (void)queryPhotosFromQuery:(PFQuery *)query
{
    if (query) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.collectionViewPhotos = [[NSMutableArray alloc] init];
            
            for (PFObject *activityObject in objects) {
                [self.collectionViewPhotos addObject:[activityObject objectForKey:kStringrActivityPhotoKey]];
               
                // just puts the string owner of a photo as the string to load in the photo detail controller
                self.stringToLoad = [[activityObject objectForKey:kStringrActivityPhotoKey] objectForKey:kStringrPhotoStringKey];
                [self.stringToLoad fetchIfNeededInBackgroundWithBlock:nil];
            }
            
            if (self.stringCollectionView) {
                [self.stringCollectionView reloadData];
            } else if (self.stringLargeCollectionView) {
                [self.stringLargeCollectionView reloadData];
            }
        }];
    }
}




#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    
    if (stringCell) {
        [stringCell.loadingImageIndicator setHidden:NO];
        [stringCell.loadingImageIndicator startAnimating];
        
        id photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
        
        if ([photo isKindOfClass:[PFObject class]]) {
            PFObject *photoObject = (PFObject *)photo;
            
            PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
            [stringCell.cellImage setFile:imageFile];
            
            [stringCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
                [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
                [stringCell.loadingImageIndicator stopAnimating];
                [stringCell.loadingImageIndicator setHidden:YES];
                image = nil;
            }];
        } else if ([photo isKindOfClass:[UIImage class]]) {
            [stringCell.cellImage setImage:photo];
            [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
            photo = nil;
        }
    }
    
    return stringCell;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    if (photo) {
        // Sends information to delegate for what cell was tapped. This allows for simple access to push details about the selected cells data.
        [self.delegate collectionView:collectionView tappedPhotoAtIndex:indexPath.item inPhotos:self.collectionViewPhotos fromString:self.stringToLoad];
    }
}




#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    NSNumber *width = 0;
    NSNumber *height = 0;
    
    if ([photo isKindOfClass:[PFObject class]]) {
        PFObject *photoObject = (PFObject *)photo;
        
        width = [photoObject objectForKey:kStringrPhotoPictureWidth];
        height = [photoObject objectForKey:kStringrPhotoPictureHeight];
    } else if ([photo isKindOfClass:[UIImage class]]) {
        UIImage *photoImage = (UIImage *)photo;
        
        width = [NSNumber numberWithInt:photoImage.size.width];
        height = [NSNumber numberWithInt:photoImage.size.height];
    }
    
    
    return CGSizeMake([width floatValue], [height floatValue]);
}
*/


@end
