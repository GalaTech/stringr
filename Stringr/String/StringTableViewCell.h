//
//  StringTableCellViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringView.h"
@interface StringTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *detailTabView;

/// Required for using this class. View StringViewDelegate for more info
- (void)setStringViewDelegate:(id<StringViewDelegate>)delegate;
//- (void)setCollectionData:(NSArray *)collectionData;
- (void)setStringObject:(PFObject *)string;
- (void)queryPhotosFromQuery:(PFQuery *)query;

@end
