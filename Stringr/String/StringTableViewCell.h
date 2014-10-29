//
//  StringTableCellViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringCollectionView.h"

static NSString *StringTableViewCellIdentifier = @"StringTableViewCell";
static NSString *StringCollectionViewCellIdentifier = @"StringCollectionViewCellIdentifier";
static CGFloat StringTableCellHeight = 270.0f;

@interface StringTableViewCell : UITableViewCell

@property (strong, nonatomic) StringCollectionView *stringCollectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
  
@end
