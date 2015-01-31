//
//  StringrPhotoCollectionViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoCollectionViewController.h"

#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"

#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Profile.h"

#import "UIColor+StringrColors.h"

@interface StringrPhotoCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NHBalancedFlowLayoutDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) CGFloat topInset;

@property (nonatomic) StringrNetworkPhotoTaskType dataType;

@end

@implementation StringrPhotoCollectionViewController

#pragma mark - Lifecycle

+ (StringrPhotoCollectionViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StringrPhotoCollectionStoryboard" bundle:nil];
    return (StringrPhotoCollectionViewController *)[storyboard instantiateInitialViewController];
}


- (instancetype)initWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user
{
    self = [StringrPhotoCollectionViewController viewController];
    
    if (self) {
        self.user = user;
        self.dataType = dataType;
    }
    
    return self;
}


- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
    NHBalancedFlowLayout *balancedLayout = [[NHBalancedFlowLayout alloc] init];
    balancedLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    balancedLayout.minimumLineSpacing = 1.0;
    balancedLayout.minimumInteritemSpacing = 1.0;
    balancedLayout.preferredRowSize = 150.0f;
    balancedLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView.collectionViewLayout = balancedLayout;
    self.collectionView.backgroundColor = [UIColor stringTableViewBackgroundColor];
}


#pragma mark - Accessors

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.collectionView reloadData];
    [self adjustScrollViewTopInset:self.topInset];
}


- (void)setDataType:(StringrNetworkPhotoTaskType)dataType
{
    [StringrNetworkTask photosForDataType:dataType user:self.user completion:^(NSArray *photos, NSError *error) {
        self.photos = photos;
    }];
}


#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.cellImage.alpha = 0.0f;
    cell.contentView.alpha = 0.0f;
    
    PFObject *photo = self.photos[indexPath.item];
    
    if (photo) {
        [cell.loadingImageIndicator setHidden:NO];
        [cell.loadingImageIndicator startAnimating];
        
        if ([photo isKindOfClass:[PFObject class]]) {
            PFObject *photoObject = (PFObject *)photo;
            
            PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
            [cell.cellImage setFile:imageFile];
            
            [cell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
                cell.cellImage.alpha = 1.0f;
                cell.contentView.alpha = 1.0f;
                [cell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
                [cell.loadingImageIndicator stopAnimating];
                [cell.loadingImageIndicator setHidden:YES];
            }];
        }
    }
    
    return cell;
}


#pragma mark - Collection View Delegate

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(160.0f, 160.0f);
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id photo = self.photos[indexPath.item];
    
    NSNumber *width = 0;
    NSNumber *height = 0;
    
    if (photo && [photo isKindOfClass:[PFObject class]]) {
        PFObject *photoObject = (PFObject *)photo;
        
        width = [photoObject objectForKey:kStringrPhotoPictureWidth];
        height = [photoObject objectForKey:kStringrPhotoPictureHeight];
    } else if (photo && [photo isKindOfClass:[UIImage class]]) {
        UIImage *photoImage = (UIImage *)photo;
        
        width = [NSNumber numberWithInt:photoImage.size.width];
        height = [NSNumber numberWithInt:photoImage.size.height];
    }
    
    
    return CGSizeMake([width floatValue], [height floatValue]);
}


#pragma mark - Stringr Container ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate containerViewDidScroll:scrollView];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [self.delegate containerViewShouldScrollToTop:scrollView];
}


- (void)adjustScrollViewTopInset:(CGFloat)inset
{
    UIEdgeInsets newInsets = self.collectionView.contentInset;
    newInsets.top = inset;
    self.topInset = inset;
    self.collectionView.contentInset = newInsets;
}


- (UIScrollView *)containerScrollView
{
    return self.collectionView;
}

@end
