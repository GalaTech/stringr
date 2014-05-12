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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterDeletePhotoFromStringKey object:nil];
}


#pragma mark - Public

// add image to locked string 
- (void)addImageToString:(UIImage *)image withBlock:(void (^)(BOOL succeeded, PFObject *photo, NSError *error))completionBlock
{
    if (image) {
        PFObject *photo = [PFObject objectWithClassName:kStringrPhotoClassKey];
        
        UIImage *resizedImage = [StringrUtility formatPhotoImageForUpload:image];
        NSData *resizedImageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", [StringrUtility randomStringWithLength:8]];
        
        PFFile *imageFileForUpload = [PFFile fileWithName:fileName data:resizedImageData];
        //[imageFileForUpload saveInBackground];
        
        [photo setObject:imageFileForUpload forKey:kStringrPhotoPictureKey];
        [photo setObject:[PFUser currentUser] forKey:kStringrPhotoUserKey];
        
        NSNumber *width = [NSNumber numberWithInt:resizedImage.size.width];
        NSNumber *height = [NSNumber numberWithInt:resizedImage.size.height];
        
        [photo setObject:width forKey:kStringrPhotoPictureWidth];
        [photo setObject:height forKey:kStringrPhotoPictureHeight];

        [photo setObject:@"" forKey:kStringrPhotoCaptionKey];
        [photo setObject:@"" forKey:kStringrPhotoDescriptionKey];
        
        PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
        //[photoACL setWriteAccess:YES forUser:[self.stringToLoad objectForKey:kStringrStringUserKey]]; // sets write access for the user uploading the photo
        [photoACL setPublicReadAccess:YES];
        [photo setACL:photoACL];
        
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                int indexOfImagePhoto = [self.collectionViewPhotos indexOfObject:resizedImage];
                [self.collectionViewPhotos replaceObjectAtIndex:indexOfImagePhoto withObject:photo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.collectionViewPhotos count] - 1 inSection:0];
                [self.stringLargeReorderableCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            } else {
                [self.collectionViewPhotos removeObject:resizedImage];
                [self.stringLargeReorderableCollectionView reloadData];
                
                UIAlertView *failedToUploadPhotoAlert = [[UIAlertView alloc] initWithTitle:@"Upload Failed" message:@"For some reason your photo failed to upload. Just try again later and everything should work fine!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [failedToUploadPhotoAlert show];
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
            [self.stringLargeReorderableCollectionView reloadData];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.collectionViewPhotos.count - 1 inSection:0];
            [self.stringLargeReorderableCollectionView insertItemsAtIndexPaths:@[indexPath]];
            
            // scroll's user to the new photo they just added. 
            [self.stringLargeReorderableCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
    }
}

- (void)removePhotoFromString:(PFObject *)photo
{
    if (photo) {
        if ([photo isKindOfClass:[PFObject class]]) {
            [self.stringPhotosToDelete addObject:photo];
        }
        
        NSUInteger indexOfPhoto = [self.collectionViewPhotos indexOfObject:photo];
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

/*
- (void)setStringWriteAccess:(BOOL)isPublic;
{
    _stringWriteAccess = isPublic;
}
 */

- (BOOL)stringIsPreparedToPublish
{
    for (PFObject *photo in self.collectionViewPhotos) {
        if (![photo isKindOfClass:[PFObject class]]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)saveAndPublishInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
    if (self.collectionViewPhotos.count > 0) {
        if (self.stringToLoad) {// editing pre-existing string
            for (int i = 0; i < self.collectionViewPhotos.count; i++) {
                PFObject *photo = [self.collectionViewPhotos objectAtIndex:i];

                if ([photo isKindOfClass:[PFObject class]]) {
                    [photo setObject:@(i) forKey:kStringrPhotoOrderNumber];
                    [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
                    [photo saveEventually];
                }
            }
            
            PFACL *stringACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [stringACL setPublicReadAccess:YES];
            [stringACL setPublicWriteAccess:self.stringWriteAccess];
            [self.stringToLoad setACL:stringACL];
            
            [self.stringToLoad setObject:self.stringTitle forKey:kStringrStringTitleKey];
            [self.stringToLoad setObject:self.stringDescription forKey:kStringrStringDescriptionKey];
            
            [self.stringToLoad saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringPublishedSuccessfully object:nil];
                }
            }];
            
            // deletes photos that the user selected in this session
            if (self.stringPhotosToDelete.count > 0) {
                for (PFObject *photo in self.stringPhotosToDelete) {
                    [photo deleteEventually];
                }
            }
        } else { // new string
            PFObject *newString = [PFObject objectWithClassName:kStringrStringClassKey];
            [newString setObject:[PFUser currentUser] forKey:kStringrStringUserKey];

            self.stringToLoad = newString;
            
            PFACL *stringACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [stringACL setPublicReadAccess:YES];
            [stringACL setPublicWriteAccess:self.stringWriteAccess];
            [self.stringToLoad setACL:stringACL];
            
            [self.stringToLoad setObject:self.stringTitle forKey:kStringrStringTitleKey];
            [self.stringToLoad setObject:self.stringDescription forKey:kStringrStringDescriptionKey];
            
            // sets the location for this newly created string
            [self.stringToLoad setObject:[[PFUser currentUser] objectForKey:kStringrUserLocationKey] forKey:kStringrStringLocationKey];
            
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
            
            // creates a statistic object for this string
            PFObject *stringStatistics = [PFObject objectWithClassName:kStringrStatisticsClassKey];
            [stringStatistics setObject:@(0) forKey:kStringrStatisticsLikeCountKey];
            [stringStatistics setObject:@(0) forKey:kStringrStatisticsCommentCountKey];
            [stringStatistics setObject:self.stringToLoad forKey:kStringrStatisticsStringKey];
            
            PFACL *stringStatisticsACL = [PFACL ACL];
            [stringStatisticsACL setPublicReadAccess:YES];
            [stringStatisticsACL setPublicWriteAccess:YES];
            [stringStatistics setACL:stringStatisticsACL];
            
            [stringStatistics saveEventually];
            
            // deletes photos that the user selected in this session
            if (self.stringPhotosToDelete.count > 0) {
                for (PFObject *photo in self.stringPhotosToDelete) {
                    [photo deleteEventually];
                }
            }
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
        if ([photo isKindOfClass:[PFObject class]]) {
            if (![photo objectForKey:kStringrPhotoStringKey]) {
                [photo deleteEventually];
            }
        }
    }
}

- (void)deleteString
{
    // delete the string and all photos in the string
    if (self.stringToLoad) {
        PFQuery *stringStatisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
        [stringStatisticsQuery whereKey:kStringrStatisticsStringKey equalTo:self.stringToLoad];
        [stringStatisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *statistic in objects) {
                    [statistic deleteEventually];
                }
            }
        }];
        
        [self.stringToLoad deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringDeletedSuccessfully object:nil];
            }
        }];
        
        for (PFObject *photo in self.collectionViewPhotos) {
            [photo deleteEventually];
        }
        
        [[PFUser currentUser] saveEventually];
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
