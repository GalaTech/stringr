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

@end
@implementation StringView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    // Register the colleciton cell for both large and normal string sizes
    // Large is only utilized on the detail string pages
    [_stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
    [_stringLargeCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
}




#pragma mark - Custom Accessors

- (void)setCollectionData:(NSMutableArray *)collectionData {
    _collectionData = collectionData;
    
    //[_stringCollectionView setContentOffset:CGPointZero animated:NO];
    //[_stringCollectionView reloadData];
}

- (NSMutableArray *)getCollectionData
{
    return _collectionData;
}









#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Gets the cell at indexPath from our collection data, which will be images.
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    
    // Creates a new cell for the collection view using the reusable cell identifier
    StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    [stringCell.cellImage setImage:nil];
    
    NSInteger rowIndex = indexPath.row;
    
    // Uses a secondary thread for loading the images into the collectionView for lag free experience
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage *cellImage = [UIImage decodedImageWithImage:[cellData objectForKey:@"image"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:stringCell];
            if (currentIndexPathForCell.row == rowIndex) {
                [stringCell.cellImage setImage:cellImage];
                [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
            }
        });
        
        
    });
    
    //UIImage *cellImage = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    //stringCell.cellImage.image = cellImage;
   
    // Sets the title for the cell
    //stringCell.cellTitle.text = [cellData objectForKey:@"title"];
    
    return stringCell;
}




#pragma mark - UICollectionView Delegate

// Posts an NSNotificationCenter notification for selecting a specific cell in the collection view.
// When one is tapped it posts a notification, which will be caught and handled appropriately
// The data at the tapped cell is sent with the notification
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCenterSelectedStringItemKey object:cellData];
}




#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photoDictionary = [self.collectionData objectAtIndex:indexPath.item];
    UIImage *image = [photoDictionary objectForKey:@"image"];
    
    return [image size];
}



@end
