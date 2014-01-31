//
//  StringTableCellViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringTableViewCell.h"
#import "StringView.h"

#import "StringrPathImageView.h"

@interface StringTableViewCell ()

@property (strong, nonatomic) StringView *stringCollectionView;

@property (strong, nonatomic) StringrPathImageView *detailTabProfileImage;
@property (strong, nonatomic) UILabel *detailTabNumberOfCommentsLabel;
@property (strong, nonatomic) UILabel *detailTabNumberOfLikesLabel;

@end


@implementation StringTableViewCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
         _stringCollectionView= [[NSBundle mainBundle] loadNibNamed:@"StringView" owner:self options:nil][0];
        _stringCollectionView.frame = self.bounds;
        [self.contentView addSubview:_stringCollectionView];
     }
    
    return self;
}




#pragma mark - Public

- (void)setCollectionData:(NSArray *)collectionData
{
    [_stringCollectionView setCollectionData:collectionData];
}




#pragma mark - Private

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
