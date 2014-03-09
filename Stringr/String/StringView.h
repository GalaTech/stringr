//
//  StringCellView.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringViewDelegate;
@protocol StringViewSubclassDelegate;

/** 
 * This view contains a UICollectionView, which is used as the container for a Strings information.
 * The event for tapping on an item in the collection view is handled through the StringViewDelegate protocol.
 */
@interface StringView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) id<StringViewDelegate> delegate;
@property (strong, nonatomic) id<StringViewSubclassDelegate> subclassDelegate;


/** 
 * Sets the data for the collection view by providing a mutable array. The array
 * is expected to contain dictionaries, which will be accessed to populate the 
 * cells of the collection view.
 * @param collectionData The mutable array of dictionaries. Each dictionary is considered
 * to be an individual photo with its accompanying information.
 */
- (void)setCollectionData:(NSMutableArray *)collectionData;

/** 
 * Sets the string parse object for the collection view.
 * This is the string object whose photo data will be loaded.
 * @param string The string object whose photos will be loaded into the collection view.
 */
- (void)setStringObject:(PFObject *)string;

/// Returns a mutable copy of the current String data.
//- (NSArray *)getCollectionData;


@end

/**
 * Returns the object that was tapped at a given index path of the collectionView. In this case that means it return's a 
 * photo PFObject. 
 *
 * It is required to use this protocol if you're using this class. Without it you will never recieve information from tapping
 * an item in the collectionView.
 */
@protocol StringViewDelegate <NSObject>

@required
- (void)collectionView:(UICollectionView *)collectionView tappedItemAtIndexPath:(NSIndexPath *)indexPath withObject:(PFObject *)photo;



@end

@protocol StringViewSubclassDelegate <NSObject>

@optional
- (void)getCollectionViewPhotoData:(NSMutableArray *)photoData;

@end