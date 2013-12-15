//
//  StringTableCellViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringCellView.h"
@interface StringTableCellViewCell : UITableViewCell

@property (strong, nonatomic) UIView *detailTabView;

- (void)setCollectionData:(NSArray *)collectionData;

@end
