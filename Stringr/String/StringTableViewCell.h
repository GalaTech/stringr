//
//  StringTableCellViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringView.h"
#import "StringCollectionView.h"

static NSString *StringCollectionViewCellIdentifier = @"StringCollectionViewCellIdentifier";

@interface StringTableViewCell : UITableViewCell

@property (strong, nonatomic) StringCollectionView *stringCollectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
 
/*
//@property (strong, nonatomic) UIView *detailTabView;

/// Required for using this class. View StringViewDelegate for more info
- (void)setStringViewDelegate:(id<StringViewDelegate>)delegate;
//- (void)setCollectionData:(NSArray *)collectionData;
- (void)setStringObject:(PFObject *)string;
- (void)queryPhotosFromQuery:(PFQuery *)query;
- (void)reloadString;
*/
  
@end
