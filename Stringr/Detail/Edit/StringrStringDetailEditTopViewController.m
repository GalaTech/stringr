//
//  StringrStringDetailTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailEditTopViewController.h"
#import "StringCollectionView.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrPhotoDetailEditTableViewController.h"
#import "StringViewReorderable.h"
#import "StringrNavigationController.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface StringrStringDetailEditTopViewController () <StringrPhotoDetailEditTableViewControllerDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringCollectionView *stringCollectionView;

@property (strong, nonatomic) NSMutableArray *stringPhotosToDelete;
@property (weak, nonatomic) StringViewReorderable *stringReorderableCollectionView;
@property (strong, nonatomic) NSString *stringTitle;
@property (strong, nonatomic) NSString *stringDescription;
@property (nonatomic) BOOL stringWriteAccess;

@end

@implementation StringrStringDetailEditTopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof (self) weakSelf = self;
    if (self.userSelectedPhoto) {
        [self.delegate toggleActionEnabledOnTableView:NO];
        [self addImageToString:self.userSelectedPhoto withBlock:^(BOOL succeeded, PFObject *photo, NSError *error) {
            if (succeeded) {
                StringrPhotoDetailViewController *editPhotoVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
                [editPhotoVC setEditDetailsEnabled:YES];
                [editPhotoVC setStringOwner:weakSelf.stringToLoad];
                [editPhotoVC setSelectedPhotoIndex:0];
                [editPhotoVC setPhotosToLoad:@[photo]];
                
                StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:editPhotoVC];
                
                [weakSelf presentViewController:navVC animated:YES completion:nil];
                
                [weakSelf.delegate toggleActionEnabledOnTableView:YES];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Custom Accessors

- (NSMutableArray *)stringPhotosToDelete
{
    if (!_stringPhotosToDelete) {
        _stringPhotosToDelete = [[NSMutableArray alloc] init];
    }
    
    return _stringPhotosToDelete;
}




#pragma mark - Public

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
                NSUInteger indexOfImagePhoto = [self.stringPhotos indexOfObject:resizedImage];
                [self.stringPhotos replaceObjectAtIndex:indexOfImagePhoto withObject:photo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.stringPhotos count] - 1 inSection:0];
                [self.stringCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            } else {
                [self.stringPhotos removeObject:resizedImage];
                [self.stringCollectionView reloadData];
                
                UIAlertView *failedToUploadPhotoAlert = [[UIAlertView alloc] initWithTitle:@"Upload Failed" message:@"For some reason your photo failed to upload. Just try again later and everything should work fine!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [failedToUploadPhotoAlert show];
            }
            
            [self.delegate toggleActionEnabledOnTableView:YES];
            
            if (completionBlock) {
                completionBlock(succeeded, photo, error);
            }
        }];
        
        [self.stringPhotos addObject:resizedImage];
        
        // if the collectionViewPhotos count == 1 that means we just added the first object.
        // That means this must be a brand new string.
        // For every other situation it must mean that we are adding a new photo to a string.
        if (self.stringPhotos.count == 1) {
            [self.stringCollectionView reloadData];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.stringPhotos.count - 1 inSection:0];
            [self.stringCollectionView insertItemsAtIndexPaths:@[indexPath]];
            
            // scroll's user to the new photo they just added.
            [self.stringCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
    }
}

- (void)removePhotoFromString:(PFObject *)photo
{
    if (photo) {
        if ([photo isKindOfClass:[PFObject class]]) {
            [self.stringPhotosToDelete addObject:photo];
        }
        
        NSUInteger indexOfPhoto = [self.stringPhotos indexOfObject:photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfPhoto inSection:0];
        [self.stringPhotos removeObjectAtIndex:indexOfPhoto];
        
        [self.stringCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)saveString
{
    if ([self stringIsPreparedToPublish]) {
        [self saveAndPublishInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)cancelString
{
    // remove all new photos that aren't associated with a string yet
    for (PFObject *photo in self.stringPhotos) {
        if ([photo isKindOfClass:[PFObject class]]) {
            if (![photo objectForKey:kStringrPhotoStringKey]) {
                [photo deleteInBackground];
            }
        }
    }
}




#pragma mark - Private

- (UICollectionViewLayout *)layoutForCollectionView
{
    LXReorderableCollectionViewFlowLayout *reorderableFlowLayout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    [reorderableFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [reorderableFlowLayout setMinimumLineSpacing:0];
    [reorderableFlowLayout setMinimumInteritemSpacing:0];
    [reorderableFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [reorderableFlowLayout setItemSize:CGSizeMake(219, 219)];
    
    return reorderableFlowLayout;
}

- (BOOL)stringIsPreparedToPublish
{
    for (PFObject *photo in self.stringPhotos) {
        if (![photo isKindOfClass:[PFObject class]]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)saveAndPublishInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
    if (self.stringPhotos.count > 0) {
        if (self.stringToLoad) {// editing pre-existing string
            for (int i = 0; i < self.stringPhotos.count; i++) {
                PFObject *photo = [self.stringPhotos objectAtIndex:i];
                
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
                    [self deletePhoto:photo];
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
                    for (int i = 0; i < self.stringPhotos.count; i++) {
                        PFObject *photo = [self.stringPhotos objectAtIndex:i];
                        
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
                    [self deletePhoto:photo];
                }
            }
        }
        
        if (completionBlock) {
            completionBlock(YES, nil);
        }
        
    } else {
        UIAlertView *noPhotosInStringAlert = [[UIAlertView alloc] initWithTitle:@"No Photos in String" message:@"You must have at least one photo in your string before you can publish it!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noPhotosInStringAlert show];
    }
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stringPhotos) {
        PFObject *photo = [self.stringPhotos objectAtIndex:indexPath.item];
        
        // makes sure that we aren't trying to move to the photo viewer with something that isn't a photo PFObject
        if (photo && [photo isKindOfClass:[PFObject class]]) {
            StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            
            [photoDetailVC setEditDetailsEnabled:YES];
            [photoDetailVC setDelegateForPhotoController:self];
            
            // Sets the photos to be displayed in the photo pager
            [photoDetailVC setPhotosToLoad:self.stringPhotos];
            [photoDetailVC setSelectedPhotoIndex:indexPath.item];
            [photoDetailVC setStringOwner:self.stringToLoad];
            
            [photoDetailVC setHidesBottomBarWhenPushed:YES];
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:photoDetailVC];
            
            [self.navigationController presentViewController:navVC animated:YES completion:nil];
        }
    }
}





#pragma mark - StringrStringDetailEditTableViewController Delegate

- (void)setTitleForString:(NSString *)title
{
    self.stringTitle = title;
}

- (void)setDescriptionForString:(NSString *)description
{
    self.stringDescription = description;
}

- (void)setWriteAccessForString:(BOOL)canWrite
{
    self.stringWriteAccess = canWrite;
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
        
        PFQuery *activitiesForString = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [activitiesForString whereKeyExists:kStringrActivityStringKey];
        [activitiesForString whereKeyExists:kStringrActivityToUserKey];
        [activitiesForString whereKey:kStringrActivityStringKey equalTo:self.stringToLoad];
        [activitiesForString findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
            if (!error) {
                for (PFObject *activity in activities) {
                    [activity deleteInBackground];
                }
            }
        }];
        
        [self.stringToLoad deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringDeletedSuccessfully object:nil];
            }
        }];
        
        for (PFObject *photo in self.stringPhotos) {
            [self deletePhoto:photo];
        }
        
        [[PFUser currentUser] saveInBackground];
    }
}

- (void)deletePhoto:(PFObject *)photo
{
    PFQuery *photoActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [photoActivityQuery whereKey:kStringrActivityPhotoKey equalTo:photo];
    [photoActivityQuery whereKeyExists:kStringrActivityPhotoKey];
    [photoActivityQuery whereKeyExists:kStringrActivityToUserKey];
    [photoActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
        }
    }];
    
    [photo deleteInBackground];
}



#pragma mark - StringrPhotoDetailEditTableViewController Delegate

- (void)deletePhotoFromString:(PFObject *)photo
{
    [self removePhotoFromString:photo];
}



#pragma mark - ReorderableCollectionView DataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    PFObject *photo = [self.stringPhotos objectAtIndex:fromIndexPath.item];
    
    [self.stringPhotos removeObjectAtIndex:fromIndexPath.item];
    [self.stringPhotos insertObject:photo atIndex:toIndexPath.item];
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
    
}

@end
