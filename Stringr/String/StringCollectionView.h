//
//  StringCollectionView.h
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringCollectionView : UICollectionView

/**
 * The index value that this String collection view lives at inside of 
 * a UITableView. The index could be either a row or section of the containing
 * table view. 
 */
@property (nonatomic, assign) NSInteger index;

@end
