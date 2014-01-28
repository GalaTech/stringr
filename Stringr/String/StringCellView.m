//
//  StringCellView.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringCellView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"
#import "StringCollectionView.h"
#import "UIImage+Decompression.h"

#import <QuartzCore/QuartzCore.h>

@interface StringCellView () <UICollectionViewDataSource, UICollectionViewDelegate, NHBalancedFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet StringCollectionView *stringCollectionView;
@property (strong, nonatomic) NSArray *collectionData;

@end
@implementation StringCellView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    //self.stringCollectionView = [[StringCollectionView alloc] initWithStringImages:_collectionData];
    //self.stringCollectionView.backgroundColor = [StringrConstants kStringCollectionViewBackgroundColor];
    
    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(157, 157);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    //StringCollectionViewFlowLayout *layout = (StringCollectionViewFlowLayout *)self.stringCollectionView.collectionViewLayout;

    
    StringCollectionViewFlowLayout *layout = [[StringCollectionViewFlowLayout alloc] init];
    
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.preferredRowSize = 320;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    
    [self.stringCollectionView setCollectionViewLayout:layout];
    
    
    
    */
    
    // Register the colleciton cell
    [_stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




#pragma mark - Custom Accessors

- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    
    //[_stringCollectionView setContentOffset:CGPointZero animated:NO];
    //[_stringCollectionView reloadData];
}





#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *cellImage = [UIImage decodedImageWithImage:[UIImage imageNamed:[cellData objectForKey:@"image"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:stringCell];
            if (currentIndexPathForCell.row == rowIndex) {
                [stringCell.cellImage setImage:cellImage];
            }
        });
        
        
    });
    
    
    
    //UIImage *cellImage = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    //stringCell.cellImage.image = cellImage;
    
    
   
    // Sets the title for the cell
    stringCell.cellTitle.text = [cellData objectForKey:@"title"];
    
    return stringCell;
}




#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photoDictionary = [self.collectionData objectAtIndex:indexPath.item];
    UIImage *image = [UIImage imageNamed:[photoDictionary objectForKey:@"image"]];
    
    return [image size];
}




#pragma mark - UICollectionView Delegate

// Posts an NSNotificationCenter notification for selecting a specific cell in the collection view.
// When one is tapped it posts a notification, which will be caught and handled appropriately
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}


@end
