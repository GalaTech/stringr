//
//  StringTableCellViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringTableCellViewCell.h"
#import "StringCellView.h"
#import "StringrDetailViewController.h"

#import "GBPathImageView.h"

@interface StringTableCellViewCell ()

@property (strong, nonatomic) StringCellView *stringCollectionView;

@property (strong, nonatomic) GBPathImageView *detailTabProfileImage;
@property (strong, nonatomic) UILabel *detailTabNumberOfCommentsLabel;
@property (strong, nonatomic) UILabel *detailTabNumberOfLikesLabel;

@end


@implementation StringTableCellViewCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
         _stringCollectionView= [[NSBundle mainBundle] loadNibNamed:@"StringCellView" owner:self options:nil][0];
        _stringCollectionView.frame = self.bounds;
        [self.contentView addSubview:_stringCollectionView];
     }
    
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCollectionData:(NSArray *)collectionData
{
    [_stringCollectionView setCollectionData:collectionData];
}


@end
