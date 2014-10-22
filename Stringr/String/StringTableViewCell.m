//
//  StringTableCellViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringTableViewCell.h"
#import "StringCollectionViewCell.h"
#import "StringrPathImageView.h"
#import "NHBalancedFlowLayout.h"

@interface StringTableViewCell ()

@end


@implementation StringTableViewCell

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        NHBalancedFlowLayout *balancedLayout = [[NHBalancedFlowLayout alloc] init];
        balancedLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        balancedLayout.minimumLineSpacing = 0;
        balancedLayout.minimumInteritemSpacing = 0;
        balancedLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        balancedLayout.preferredRowSize = 4000.0f;
        
        self.stringCollectionView = [[StringCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:balancedLayout];
        [self.stringCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StringCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:StringCollectionViewCellIdentifier];
        [self.stringCollectionView setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
        self.stringCollectionView.showsHorizontalScrollIndicator = NO;
        self.stringCollectionView.scrollsToTop = NO;
        [self.contentView addSubview:self.stringCollectionView];
     }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    self.stringCollectionView.layer.masksToBounds = NO;
    self.stringCollectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.stringCollectionView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.stringCollectionView.layer.shadowOpacity = 0.5f;
    self.stringCollectionView.layer.shouldRasterize = YES;
    self.stringCollectionView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    */
    
    self.stringCollectionView.frame = self.contentView.bounds;
}



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.stringCollectionView.dataSource = dataSourceDelegate;
    self.stringCollectionView.delegate = dataSourceDelegate;
    self.stringCollectionView.index = index;
    
    [self.stringCollectionView reloadData];
}

@end
