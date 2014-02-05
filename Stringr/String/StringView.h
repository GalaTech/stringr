//
//  StringCellView.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This view contains a UICollectionView, which is used as the container for a Strings information.
 * The event for tapping on an item in the collection view is handled through NSNotificationCenter.
 */
@interface StringView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

/** Sets the data for the collection view by providing a mutable array. The array
 * is expected to contain dictionaries, which will be accessed to populate the 
 * cells of the collection view.
 *
 * @param collectionData The mutable array of dictionaries. Each dictionary is considered
 * to be an individual photo with its accompanying information.
 */
- (void)setCollectionData:(NSMutableArray *)collectionData;

/// Returns a mutable copy of the current String data.
- (NSMutableArray *)getCollectionData;


@end
