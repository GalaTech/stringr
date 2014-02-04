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

@end

@implementation StringViewReorderable

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [_stringLargeReorderableCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];

}


#pragma mark - ReorderableCollectionView DataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSDictionary *stringImage = [[self getCollectionData] objectAtIndex:fromIndexPath.item];
    NSMutableArray *collectionData = [self getCollectionData];
    
    [collectionData removeObjectAtIndex:fromIndexPath.item];
    [collectionData insertObject:stringImage atIndex:toIndexPath.item];
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
