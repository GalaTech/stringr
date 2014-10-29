//
//  StringrStringTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTopViewController.h"
#import "StringCollectionView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrNavigationController.h"
#import "StringrFooterView.h"
#import "StringrNetworkTask+PushNotification.h"
#import "UIColor+StringrColors.h"

@interface StringrStringDetailTopViewController () <NHBalancedFlowLayoutDelegate, StringrPhotoDetailEditTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringCollectionView *stringCollectionView;

@end

@implementation StringrStringDetailTopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This is of type NHBalancedFlowLayout
    UICollectionViewLayout *balancedLayout = [self layoutForCollectionView];
    
    CGRect stringCollectionViewRect = self.stringView.bounds;
    stringCollectionViewRect.size.width = [UIScreen mainScreen].bounds.size.width;
    
    self.stringCollectionView = [[StringCollectionView alloc] initWithFrame:stringCollectionViewRect collectionViewLayout:balancedLayout];
    [self.stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCellIdentifier"];
    [self.stringCollectionView setBackgroundColor:[UIColor stringCollectionViewBackgroundColor]];
    self.stringCollectionView.showsHorizontalScrollIndicator = NO;
    self.stringCollectionView.scrollsToTop = NO;
    self.stringCollectionView.dataSource = self;
    self.stringCollectionView.delegate = self;
    [self.stringView addSubview:self.stringCollectionView];

    self.view.backgroundColor = [UIColor stringCollectionViewBackgroundColor];
    
    [self queryPhotosFromString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoRemovedFromPublicString:) name:kNSNotificationCenterReloadPublicString object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterReloadPublicString object:nil];
    
}



//*********************************************************************************/
#pragma mark - Custom Accessors
//*********************************************************************************/

- (NSMutableArray *)stringPhotos
{
    if (!_stringPhotos) {
        _stringPhotos = [[NSMutableArray alloc] init];
    }
    
    return _stringPhotos;
}



//*********************************************************************************/
#pragma mark - Action Handlers
//*********************************************************************************/

- (void)photoRemovedFromPublicString:(NSNotification *)notification
{
    // gets the photo that has been deleted by a user and removes it from the current string
    NSDictionary *notificationDictionary = [notification userInfo];
    PFObject *photo = [notificationDictionary objectForKey:@"photo"];
    
    if (photo) {
        NSInteger indexOfPhoto = [self.stringPhotos indexOfObject:photo];

        [photo deleteInBackground];
        if (indexOfPhoto <= self.stringPhotos.count) {
            [self.stringPhotos removeObjectAtIndex:indexOfPhoto];
            NSIndexPath *photoIndexPath = [NSIndexPath indexPathForItem:indexOfPhoto inSection:0];
            [self.stringCollectionView deleteItemsAtIndexPaths:@[photoIndexPath]];
        }
    }
}



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)queryPhotosFromString
{
    if (self.stringToLoad) {
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:self.stringToLoad];
        [stringPhotoQuery orderByAscending:@"photoOrder"]; // photoOrder: each photo has a number associated with where it falls into the string
        [stringPhotoQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if (!error) {
                self.stringPhotos = [[NSMutableArray alloc] initWithArray:photos];
                [self.stringCollectionView reloadData];
            }
        }];
    }
}

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
        [photo setObject:@(self.stringPhotos.count) forKey:kStringrPhotoOrderNumber];
        
        PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [photoACL setWriteAccess:YES forUser:[self.stringToLoad objectForKey:kStringrStringUserKey]]; // sets write access for the user uploading the photo
        [photoACL setPublicReadAccess:YES];
        [photo setACL:photoACL];
        
        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSUInteger indexOfImagePhoto = [self.stringPhotos indexOfObject:resizedImage];
                [self.stringPhotos replaceObjectAtIndex:indexOfImagePhoto withObject:photo];
                
                 NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfImagePhoto inSection:0];

                [self.stringCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            
            [self sendActivityNotificationForAddingPhoto:photo];
            
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
            [self.stringCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (UICollectionViewLayout *)layoutForCollectionView
{
    NHBalancedFlowLayout *balancedLayout = [[NHBalancedFlowLayout alloc] init];
    balancedLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    balancedLayout.minimumLineSpacing = 0;
    balancedLayout.minimumInteritemSpacing = 0;
    balancedLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    balancedLayout.preferredRowSize = 320;
    
    return balancedLayout;
}

/// Sends an activity notification to the string owner.
/// @param photo The photo that has been added to the string
- (void)sendActivityNotificationForAddingPhoto:(PFObject *)photo
{
    PFUser *user = [self.stringToLoad objectForKey:kStringrStringUserKey];
    
    PFObject *addPhotoToPublicStringActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
    [addPhotoToPublicStringActivity setObject:kStringrActivityTypeAddedPhotoToPublicString forKey:kStringrActivityTypeKey];
    [addPhotoToPublicStringActivity setObject:user forKey:kStringrActivityToUserKey];
    [addPhotoToPublicStringActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
    [addPhotoToPublicStringActivity setObject:self.stringToLoad forKey:kStringrActivityStringKey];
    [addPhotoToPublicStringActivity setObject:photo forKey:kStringrActivityPhotoKey];
    
    PFACL *addPhotoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [addPhotoACL setPublicReadAccess:YES];
    [addPhotoACL setPublicWriteAccess:YES];
    [addPhotoToPublicStringActivity setACL:addPhotoACL];
    
    [addPhotoToPublicStringActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [StringrNetworkTask sendContributedToStringPushNotification:self.stringToLoad withPhoto:photo];
    }];
}



//*********************************************************************************/
#pragma mark - UICollectionView Data Source
//*********************************************************************************/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(StringCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.stringPhotos.count;
}

- (UICollectionViewCell *)collectionView:(StringCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        
        id photo = self.stringPhotos[indexPath.item];
        
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        
        [stringCell.loadingImageIndicator setHidden:NO];
        [stringCell.loadingImageIndicator startAnimating];
        
        if ([photo isKindOfClass:[PFObject class]]) {
            PFObject *photoObject = (PFObject *)photo;
            
            PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
            [stringCell.cellImage setFile:imageFile];
            
            [stringCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
                [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
                [stringCell.loadingImageIndicator stopAnimating];
                [stringCell.loadingImageIndicator setHidden:YES];
            }];
        } else if ([photo isKindOfClass:[UIImage class]]) {
            [stringCell.cellImage setImage:photo];
            [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
        }
        
        return stringCell;
    } else {
        return nil;
    }
}



//*********************************************************************************/
#pragma mark - UICollectionView Delegate
//*********************************************************************************/

- (void)collectionView:(StringCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stringPhotos) {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:self.stringPhotos];
        [photoDetailVC setSelectedPhotoIndex:indexPath.item];
        [photoDetailVC setStringOwner:self.stringToLoad];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
    
}



//*********************************************************************************/
#pragma mark - StringCollectionViewFlowLayout Delegate
//*********************************************************************************/

- (CGSize)collectionView:(StringCollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id photo = self.stringPhotos[indexPath.item];
    
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


/*
#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        [photoDetailVC setStringOwner:string];
        
        // Sets the initial photo to the selected cell's PFObject photo data
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setEditDetailsEnabled:NO];

        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}
 */

@end
