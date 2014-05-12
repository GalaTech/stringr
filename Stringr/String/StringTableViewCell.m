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

@property (weak, nonatomic) StringView *stringCollectionView;

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

- (void)prepareForReuse
{
}

- (void)dealloc
{
    NSLog(@"dealloc string table view cell");
}



#pragma mark - Public

/*
- (void)setCollectionData:(NSArray *)collectionData
{
    [_stringCollectionView setCollectionData:[collectionData mutableCopy]];
}
 */

- (void)setStringObject:(PFObject *)string
{
    [_stringCollectionView setStringObject:string];
}

- (void)setStringViewDelegate:(id<StringViewDelegate>)delegate
{
    [_stringCollectionView setDelegate:delegate];
}

- (void)queryPhotosFromQuery:(PFQuery *)query
{
    [_stringCollectionView queryPhotosFromQuery:query];
}

- (void)reloadString
{
    [_stringCollectionView reloadString];
}


#pragma mark - Private

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
