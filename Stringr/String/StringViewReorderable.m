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
@property (strong, nonatomic) NSMutableArray *collectionData;
@property (strong, nonatomic) NSMutableArray *collectionViewPhotosData; // of Photo PFObject's

@end

@implementation StringViewReorderable

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [_stringLargeReorderableCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
    //_collectionData = [self getCollectionData];
    
    
}




#pragma mark - Custom Accessors
/*
- (NSMutableArray *)collectionViewPhotosData
{
    if (!_collectionViewPhotosData) {
        _collectionViewPhotosData = [[NSMutableArray alloc] init];
    }
    
    return _collectionViewPhotosData;
}
*/


#pragma mark - Public

- (void)addPhotoToString:(NSDictionary *)photo
{
    if (photo) {
        [self.collectionData addObject:photo];
        
        // Index path for the end of the String data
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.collectionData count] - 1 inSection:0];
        
        [self.stringLargeReorderableCollectionView insertItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)removePhotoFromString:(NSDictionary *)photo
{
    if (photo) {
        NSUInteger indexOfPhoto = [self.collectionData indexOfObject:photo];
        if (indexOfPhoto < 100) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexOfPhoto inSection:0];
            [self.collectionData removeObjectAtIndex:indexOfPhoto];
            
            [self.stringLargeReorderableCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
}

- (void)removePhotoFromStringAtIndex:(NSInteger)index
{
    
}



#pragma mark - StringrViewSubclass Delegate

- (void)getCollectionViewPhotoData:(NSMutableArray *)photoData
{
    _collectionViewPhotosData = [[NSMutableArray alloc] initWithArray:photoData];
}



#pragma mark - ReorderableCollectionView DataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    PFObject *photo = [self.collectionViewPhotosData objectAtIndex:fromIndexPath.item];
    
    [self.collectionViewPhotosData removeObjectAtIndex:fromIndexPath.item];
    [self.collectionViewPhotosData insertObject:photo atIndex:toIndexPath.item];
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