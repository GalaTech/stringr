//
//  StringCellView.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)setCollectionData:(NSMutableArray *)collectionData;
- (NSMutableArray *)getCollectionData;

@end
