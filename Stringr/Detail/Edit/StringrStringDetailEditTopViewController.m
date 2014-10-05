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
#import "StringrNavigationController.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface StringrStringDetailEditTopViewController () <StringrPhotoDetailEditTableViewControllerDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *stringView;

@property (strong, nonatomic) StringCollectionView *stringCollectionView;
@property (strong, nonatomic) NSMutableArray *stringPhotosToDelete;
@property (strong, nonatomic) NSString *stringTitle;
@property (strong, nonatomic) NSString *stringDescription;
@property (nonatomic) BOOL stringWriteAccess;

@end

@implementation StringrStringDetailEditTopViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];

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



//*********************************************************************************/
#pragma mark - Custom Accessors
//*********************************************************************************/

- (NSMutableArray *)stringPhotosToDelete
{
    if (!_stringPhotosToDelete) {
        _stringPhotosToDelete = [[NSMutableArray alloc] init];
    }
    
    return _stringPhotosToDelete;
}

- (void)setUserSelectedPhoto:(UIImage *)userSelectedPhoto
{
    _userSelectedPhoto = userSelectedPhoto;
    
    if (_userSelectedPhoto) {
        __weak typeof (self) weakSelf = self;
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
                weakSelf.userSelectedPhoto = nil;
            }
        }];
    }
}

- (void)setUserSelectedPhotos:(NSArray *)userSelectedPhotos
{
    _userSelectedPhotos = userSelectedPhotos;
    
    if (_userSelectedPhotos) {
        for (UIImage *image in self.userSelectedPhotos) {
            [self addImageToString:image withBlock:nil];
        }
        [self.stringCollectionView reloadData];
        self.userSelectedPhotos = nil; // resets the array so that the assets won't be reused
    }
}



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)addImageToString:(UIImage *)image withBlock:(void (^)(BOOL succeeded, PFObject *photo, NSError *error))completionBlock
{
    if (image) {
        PFObject *photo = [PFObject objectWithClassName:kStringrPhotoClassKey];
        
        UIImage *resizedImage = [StringrUtility formatPhotoImageForUpload:image];
        
        __block NSData *resizedImageData = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            resizedImageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", [StringrUtility randomStringWithLength:8]];
            
            PFFile *imageFileForUpload = [PFFile fileWithName:fileName data:resizedImageData];
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
                    NSUInteger indexOfPhoto = [self.stringPhotos indexOfObject:resizedImage];
                    [self.stringPhotos replaceObjectAtIndex:indexOfPhoto withObject:photo];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfPhoto inSection:0];
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
        });

        [self.stringPhotos addObject:resizedImage];
        
        if (self.userSelectedPhotos) { // return because in the setter for userSelectedPhotos I reloadData after all images have been added
            return;
        } else if (self.stringPhotos.count == 1) { // this means it's a new string
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
        
//        UIAlertView *saveStringAlertView = [[UIAlertView alloc] initWithTitle:@"String Saved" message:@"Your String has been saved and will be published in the background." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [saveStringAlertView show];
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



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

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
    // All photos must be of type PFObject
    for (PFObject *photo in self.stringPhotos) {
        if (![photo isKindOfClass:[PFObject class]]) {
            return NO;
        }
    }
    
    // String title must contain characters/content
    if ([self.stringTitle isEqualToString:@"Enter the title for your String"] || ![StringrUtility NSStringContainsCharactersWithoutWhiteSpace:self.stringTitle]) {
        UIAlertView *mustEditTitle = [[UIAlertView alloc] initWithTitle:@"String Title" message:@"You need to set a title for your String!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mustEditTitle show];
        
        return NO;
    }
    
    return YES;
}

- (void)saveAndPublishInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
    if (self.stringPhotos.count > 0) {
        if (self.stringToLoad) {// editing pre-existing string
            // Sets string data for all photos in the string
            for (int i = 0; i < self.stringPhotos.count; i++) {
                PFObject *photo = [self.stringPhotos objectAtIndex:i];
                
                if ([photo isKindOfClass:[PFObject class]]) {
                    [photo setObject:@(i) forKey:kStringrPhotoOrderNumber];
                    [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
                    [photo saveInBackground];
                }
            }
            
            PFACL *stringACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [stringACL setPublicReadAccess:YES];
            [stringACL setPublicWriteAccess:self.stringWriteAccess];
            [self.stringToLoad setACL:stringACL];
            
            [self.stringToLoad setObject:self.stringTitle forKey:kStringrStringTitleKey];
            [self.stringToLoad setObject:self.stringDescription forKey:kStringrStringDescriptionKey];
            
            [self.stringToLoad saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringPublishedSuccessfully object:nil];
                }
            }];
            
            // Creates activity notifications for any user who is mentioned in this strings title/description
            [self findAndSendNotificationToMentionsInString:self.stringToLoad];
            
            // deletes photos that the user selected to delete in this session
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
            if ([[PFUser currentUser] objectForKey:kStringrUserLocationKey]) {
                [self.stringToLoad setObject:[[PFUser currentUser] objectForKey:kStringrUserLocationKey] forKey:kStringrStringLocationKey];
            }
            
            [self.stringToLoad saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    for (int i = 0; i < self.stringPhotos.count; i++) {
                        PFObject *photo = [self.stringPhotos objectAtIndex:i];
                        
                        [photo setObject:@(i) forKey:kStringrPhotoOrderNumber];
                        [photo setObject:self.stringToLoad forKey:kStringrPhotoStringKey];
                        [photo saveInBackground];
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
            
            [stringStatistics saveInBackground];
            
            // deletes photos that the user selected to delete in this session
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

- (void)findAndSendNotificationToMentionsInString:(PFObject *)string
{
    // Extracts all of the @mentions from the title and description of the string
    NSArray *titleMentions = [StringrUtility mentionsContainedWithinString:self.stringTitle];
    NSArray *descriptionMentions = [StringrUtility mentionsContainedWithinString:self.stringDescription];
    
    NSMutableSet *combinedMentionsSet = [NSMutableSet setWithArray:titleMentions];
    [combinedMentionsSet addObjectsFromArray:descriptionMentions];
    
    NSArray *combinedMentionsArray = [combinedMentionsSet allObjects];
    
    // Finds all users whose username matches these mentions.
    PFQuery *mentionUsersQuery = [PFUser query];
    [mentionUsersQuery whereKey:kStringrUserUsernameKey containedIn:combinedMentionsArray];
    [mentionUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (!error) {
            // Finds any activities that might already exist for the mentioned usernames on this string
            PFQuery *activityMentionQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
            [activityMentionQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeMention];
            [activityMentionQuery whereKey:kStringrActivityStringKey equalTo:string];
            [activityMentionQuery whereKey:kStringrActivityToUserKey containedIn:users];
            [activityMentionQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
            [activityMentionQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
                if (!error) {
                    // delete any activities that already existed so that there will not be duplicates
                    for (PFObject *activity in activities) {
                        [activity deleteInBackground];
                    }
                    
                    // Create a new mention activity for all users who were mentioned in the string
                    for (PFUser *user in users) {
                        if (![user.objectId isEqualToString:[PFUser currentUser].objectId]){
                            PFObject *mentionActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
                            [mentionActivity setObject:kStringrActivityTypeMention forKey:kStringrActivityTypeKey];
                            [mentionActivity setObject:user forKey:kStringrActivityToUserKey];
                            [mentionActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
                            [mentionActivity setObject:string forKey:kStringrActivityStringKey];
                            
                            PFACL *mentionACL = [PFACL ACLWithUser:[PFUser currentUser]];
                            [mentionACL setPublicReadAccess:YES];
                            [mentionACL setPublicWriteAccess:YES];
                            [mentionActivity setACL:mentionACL];
                            
                            [mentionActivity saveInBackground];
                        }
                    }
                }
            }];
        }
    }];
}


//*********************************************************************************/
#pragma mark - UICollectionView Delegate
//*********************************************************************************/

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




//*********************************************************************************/
#pragma mark - StringrStringDetailEditTableViewController Delegate
//*********************************************************************************/

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
        PFQuery *activitiesForString = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [activitiesForString whereKey:kStringrActivityStringKey equalTo:self.stringToLoad];
        [activitiesForString findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
            if (!error) {
                for (PFObject *activity in activities) {
                    [activity deleteInBackground];
                }
            }
            
            PFQuery *stringStatisticsQuery = [PFQuery queryWithClassName:kStringrStatisticsClassKey];
            [stringStatisticsQuery whereKey:kStringrStatisticsStringKey equalTo:self.stringToLoad];
            [stringStatisticsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *statistic in objects) {
                        [statistic deleteInBackground];
                    }
                }
                
            }];
            
            [self.stringToLoad deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterStringDeletedSuccessfully object:nil];
                }
                
                for (PFObject *photo in self.stringPhotos) {
                    [self deletePhoto:photo];
                }
            }];
            
            
        }];

        

    }
}

- (void)deletePhoto:(PFObject *)photo
{
    PFQuery *photoActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [photoActivityQuery whereKey:kStringrActivityPhotoKey equalTo:photo];
    [photoActivityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
            
            [photo deleteInBackground];
        }
    }];
}



//*********************************************************************************/
#pragma mark - StringrPhotoDetailEditTableViewController Delegate
//*********************************************************************************/

- (void)deletePhotoFromString:(PFObject *)photo
{
    [self removePhotoFromString:photo];
}



//*********************************************************************************/
#pragma mark - ReorderableCollectionView DataSource
//*********************************************************************************/

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



//*********************************************************************************/
#pragma mark - ReorderableCollectionView Delegate
//*********************************************************************************/

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
