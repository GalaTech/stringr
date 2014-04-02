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

@interface StringView () <NHBalancedFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet StringCollectionView *stringCollectionView;
@property (weak, nonatomic) IBOutlet StringCollectionView *stringLargeCollectionView;

@property (strong, nonatomic) NSMutableArray *collectionData;

@property (strong, nonatomic) PFObject *stringToLoad; // string PFObject
@property (strong, nonatomic) NSArray *collectionViewPhotos; // of Photo PFObject's

@end
@implementation StringView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    // Register the colleciton cell for both large and normal string sizes
    [_stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
    // Large is only utilized on the detail string pages
    [_stringLargeCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];    
}




#pragma mark - Custom Accessors

- (void)setCollectionData:(NSMutableArray *)collectionData {
    _collectionData = collectionData;
}

- (void)setStringObject:(PFObject *)string
{
    _stringToLoad = string;
    
    
    
    // queries parse after a string object has been set to load
    [self queryPhotosFromString];
}

- (NSMutableArray *)getCollectionData
{
    return [_collectionViewPhotos mutableCopy];
}



#pragma mark - Private

- (void)refreshString
{
    [self queryPhotosFromString];
}



#pragma mark - Parse

- (void)queryPhotosFromString
{
    if (self.stringToLoad) {
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery orderByAscending:@"createdAt"];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:self.stringToLoad];
        
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if (!error) {
                self.collectionViewPhotos = [[NSArray alloc] initWithArray:photos];
                [self.subclassDelegate getCollectionViewPhotoData:[self getCollectionData]];
                
                if (self.stringCollectionView) {
                    [self.stringCollectionView reloadData];
                } else if (self.stringLargeCollectionView) {
                    [self.stringLargeCollectionView reloadData];
                }
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
    
    stringCell.tag = indexPath.item;
    
    [stringCell.loadingImageIndicator setHidden:NO];
    [stringCell.loadingImageIndicator startAnimating];
    
    PFObject *photoObject = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
    [stringCell.cellImage setFile:imageFile];
    [stringCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
        [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
        [stringCell.loadingImageIndicator stopAnimating];
        [stringCell.loadingImageIndicator setHidden:YES];
    }];
    
    
    return stringCell;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //PFObject *cellData = [self.collectionViewPhotos objectAtIndex:indexPath.row]; // PFObject(Photo)
    [self.delegate collectionView:collectionView tappedPhotoAtIndex:indexPath.row inPhotos:self.collectionViewPhotos fromString:self.stringToLoad];
}




#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    NSNumber *width = [photo objectForKey:kStringrPhotoPictureWidth];
    NSNumber *height = [photo objectForKey:kStringrPhotoPictureHeight];
    
    return CGSizeMake([width floatValue], [height floatValue]);
}



@end
