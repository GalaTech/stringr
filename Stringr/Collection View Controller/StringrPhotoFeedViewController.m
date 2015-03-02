//
//  StringrPhotoCollectionViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoFeedViewController.h"

#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"

#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Profile.h"

#import "UIColor+StringrColors.h"

@interface StringrPhotoFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, StringrPhotoFeedModelControllerDelegate, NHBalancedFlowLayoutDelegate>

@property (nonatomic) StringrNetworkPhotoTaskType dataType;

@end

@implementation StringrPhotoFeedViewController

#pragma mark - Lifecycle

+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StringrPhotoCollectionStoryboard" bundle:nil];
    return (StringrPhotoFeedViewController *)[storyboard instantiateInitialViewController];
}


+ (instancetype)photoFeedWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user
{
    StringrPhotoFeedViewController *photoFeedVC = [StringrPhotoFeedViewController viewController];
    photoFeedVC.modelController.user = user;
    photoFeedVC.modelController.dataType = dataType;
    
    return photoFeedVC;
}


+ (instancetype)photoFeedFromString:(StringrString *)string
{
    StringrPhotoFeedViewController *photoFeedVC = [StringrPhotoFeedViewController viewController];
    photoFeedVC.modelController.string = string;
    
    return photoFeedVC;
}


+ (instancetype)photoFeedFromPhotos:(NSArray *)photos
{
    StringrPhotoFeedViewController *photoFeedVC = [StringrPhotoFeedViewController viewController];
    photoFeedVC.modelController.photos = photos;
    
    return photoFeedVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAppearance];
}


- (void)setupAppearance
{
    NHBalancedFlowLayout *balancedLayout = [[NHBalancedFlowLayout alloc] init];
    balancedLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    balancedLayout.minimumLineSpacing = 2.0;
    balancedLayout.minimumInteritemSpacing = 2.0;
    balancedLayout.preferredRowSize = 150.0f;
    balancedLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.collectionViewLayout = balancedLayout;
    self.collectionView.backgroundColor = [UIColor stringTableViewBackgroundColor];
}


#pragma mark - Accessors

- (StringrPhotoFeedModelController *)modelController
{
    if (!_modelController) {
        _modelController = [StringrPhotoFeedModelController new];
        _modelController.delegate = self;
    }
    
    return _modelController;
}


#pragma mark - <StringrPhotoFeedModelControllerDelegate>

- (void)photoDataDidUpdate
{
    [self.collectionView reloadData];
}


#pragma mark - <CollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelController.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    StringrPhoto *photo = self.modelController.photos[indexPath.item];
        
    if (photo) {
        [stringCell.loadingImageIndicator setHidden:NO];
        [stringCell.loadingImageIndicator startAnimating];
        
        [photo loadImageInBackground:^(UIImage *image, NSError *error) {
            stringCell.cellImage.image = image;
            [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
            [stringCell.loadingImageIndicator stopAnimating];
            [stringCell.loadingImageIndicator setHidden:YES];
            
            [UIView animateWithDuration:0.2 animations:^{
                stringCell.cellImage.alpha = 1.0f;
            }];
        }];
    }
    
    return stringCell;
}


#pragma mark - <CollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringrPhoto *photo = self.modelController.photos[indexPath.item];
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (photo) {
        width = photo.width;
        height = photo.height;
    }
    
    return CGSizeMake(width, height);
}

@end
