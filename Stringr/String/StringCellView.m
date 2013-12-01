//
//  StringCellView.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringCellView.h"
#import "StringCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface StringCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *stringCollectionView;
@property (strong, nonatomic) NSArray *collectionData;

@end
@implementation StringCellView

- (void)awakeFromNib
{
    self.stringCollectionView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(170.0, 170.0);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self.stringCollectionView setCollectionViewLayout:flowLayout];
    
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


#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    
    [_stringCollectionView setContentOffset:CGPointZero animated:NO];
    [_stringCollectionView reloadData];
}




#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Creates a new cell for the collection view using the reusable cell identifier
    StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    
    // Gets the cell at indexPath from our collection data, which will be images.
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    // Sets the title for the cell
    stringCell.cellTitle.text = [cellData objectForKey:@"title"];
    
    UIImage *cellImage = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    stringCell.cellImage.image = cellImage;
    
    return stringCell;
}


// Posts an NSNotificationCenter notification for selecting a specific cell in the collection view.
// When one is tapped it posts a notification, which will be caught and handled appropriately
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
}


@end
