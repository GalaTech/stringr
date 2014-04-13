//
//  StringViewReorderable.m
//  Stringr
//
//  Created by Jonathan Howard on 2/2/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringViewReorderable.h"
#import "StringEditCollectionView.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface StringViewReorderable () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet StringEditCollectionView *stringLargeReorderableCollectionView;

@property (strong, nonatomic) NSString *stringTitle;
@property (strong, nonatomic) NSString *stringDescription;
@property (nonatomic) BOOL stringWriteAccess;

//@property (strong, nonatomic) NSMutableArray *collectionData;
//@property (strong, nonatomic) NSMutableArray *collectionViewPhotosData; // of Photo PFObject's

@end

@implementation StringViewReorderable

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [_stringLargeReorderableCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
}




#pragma mark - Public

- (void)addImageToString:(UIImage *)image
{
    if (image) {
        PFObject *photo = [PFObject objectWithClassName:kStringrPhotoClassKey];
        
        UIImage *resizedImage = [StringrUtility formatPhotoImageForUpload:image];
        NSData *resizedImageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
        
        PFFile *imageFileForUpload = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg", [StringrUtility randomStringWithLength:10]] data:resizedImageData];

        [photo setObject:imageFileForUpload forKey:kStringrPhotoPictureKey];
        [photo setObject:[PFUser currentUser] forKey:kStringrPhotoUserKey];
        
        NSNumber *width = [NSNumber numberWithInt:resizedImage.size.width];
        NSNumber *height = [NSNumber numberWithInt:resizedImage.size.height];
        
        [photo setObject:width forKey:kStringrPhotoPictureWidth];
        [photo setObject:height forKey:kStringrPhotoPictureHeight];
        
        [photo setObject:@(0) forKey:kStringrPhotoNumberOfCommentsKey];
        [photo setObject:@(0) forKey:kStringrPhotoNumberOfLikesKey];
        [photo setObject:@"" forKey:kStringrPhotoCaptionKey];
        
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                int indexOfImagePhoto = [self.collectionViewPhotos indexOfObject:resizedImage];
                [self.collectionViewPhotos replaceObjectAtIndex:indexOfImagePhoto withObject:photo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionViewPhotos count] - 1 inSection:0];
                //[self.stringLargeReorderableCollectionView insertItemsAtIndexPaths:@[indexPath]];
                [self.stringLargeReorderableCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
        
        [self.collectionViewPhotos addObject:resizedImage];
        
        // if the collectionViewPhotos count == 1 that means we just added the first object.
        // That means this must be a brand new string.
        // For every other situation it must mean that we are adding a new photo to a string.
        if (self.collectionViewPhotos.count == 1) {
            [self.stringLargeReorderableCollectionView reloadData];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.collectionViewPhotos.count - 1 inSection:0];
            [self.stringLargeReorderableCollectionView insertItemsAtIndexPaths:@[indexPath]];
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
        
        [self.stringLargeReorderableCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)setStringTitle:(NSString *)stringTitle
{
    _stringTitle = stringTitle;
}

- (void)setStringDescription:(NSString *)stringDescription
{
    _stringDescription = stringDescription;
}

- (void)setStringWriteAccess:(BOOL)isPublic;
{
    _stringWriteAccess = isPublic;
}

- (void)saveAndPublishInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
    if (self.collectionViewPhotos.count > 0) {
        if (self.stringToLoad) {
            for (int i = 0; i < self.collectionViewPhotos.count; i++) {
                PFObject *photo = [self.collectionViewPhotos objectAtIndex:i];
                [photo setObject:@(i) forKey:kStringrPhotoOrderNumber];
                [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
                [photo saveEventually];
            }
            
            PFACL *stringACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [stringACL setPublicReadAccess:YES];
            [stringACL setPublicWriteAccess:self.stringWriteAccess];
            [self.stringToLoad setACL:stringACL];
            
            [self.stringToLoad saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringPublishedSuccessfully object:nil];
                }
            }];
        } else {
            PFObject *newString = [PFObject objectWithClassName:kStringrStringClassKey];
            [newString setObject:[PFUser currentUser] forKey:kStringrStringUserKey];
            [newString setObject:@(0) forKey:kStringrStringNumberOfCommentsKey];
            [newString setObject:@(0) forKey:kStringrStringNumberOfLikesKey];
            
            self.stringToLoad = newString;
            [self.stringToLoad saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    for (int i = 0; i < self.collectionViewPhotos.count; i++) {
                        PFObject *photo = [self.collectionViewPhotos objectAtIndex:i];
                        [photo setObject:@(i) forKey:kStringrPhotoOrderNumber];
                        [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
                        [photo saveEventually];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringPublishedSuccessfully object:nil];
                }
            }];
        }
        
        if (completionBlock) {
            completionBlock(YES, nil);
        }
        
        UIAlertView *publishingStringAlerView = [[UIAlertView alloc] initWithTitle:@"Saving String" message:@"Your string will be saved and published in the background." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [publishingStringAlerView show];
    } else {
        UIAlertView *noPhotosInStringAlert = [[UIAlertView alloc] initWithTitle:@"No Photo's in String" message:@"You must have at least one photo in your string before you can publish it!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noPhotosInStringAlert show];
    }
}

- (void)cancelString
{
    // remove all new photos that aren't associated with a string yet
    for (PFObject *photo in self.collectionViewPhotos) {
        if (![photo objectForKey:kStringrPhotoStringKey]) {
            [photo deleteEventually];
        }
    }
}

- (void)deleteString
{
    // delete the string and all photos in the string
    if (self.stringToLoad) {
        [self.stringToLoad deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringDeletedSuccessfully object:nil];
            }
        }];
        
        for (PFObject *photo in self.collectionViewPhotos) {
            [photo deleteEventually];
        }
    }
}


#pragma mark - ReorderableCollectionView DataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    PFObject *photo = [self.collectionViewPhotos objectAtIndex:fromIndexPath.item];
    
    [self.collectionViewPhotos removeObjectAtIndex:fromIndexPath.item];
    [self.collectionViewPhotos insertObject:photo atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}




#pragma mark - ReorderableCollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:self.images forKey:kUserDefaultsWorkingStringSavedImagesKey];
    //[defaults synchronize];
}

@end
