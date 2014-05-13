//
//  StringTableCellViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringTableViewCell.h"
#import "StringView.h"
#import "StringCollectionViewCell.h"
#import "StringrPathImageView.h"
#import "NHBalancedFlowLayout.h"

@interface StringTableViewCell ()

//@property (weak, nonatomic) StringView *stringView;

@end


@implementation StringTableViewCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        /*
        // Initialization code
         _stringView= [[NSBundle mainBundle] loadNibNamed:@"StringView" owner:self options:nil][0];
        _stringView.frame = self.bounds;
        [self.contentView addSubview:_stringView];
         */
        
        NHBalancedFlowLayout *balancedLayout = [[NHBalancedFlowLayout alloc] init];
        balancedLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        balancedLayout.minimumLineSpacing = 0;
        balancedLayout.minimumInteritemSpacing = 0;
        balancedLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        balancedLayout.preferredRowSize = 320;
        
        self.stringCollectionView = [[StringCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:balancedLayout];
        [self.stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:StringCollectionViewCellIdentifier];
        [self.stringCollectionView setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
        self.stringCollectionView.showsHorizontalScrollIndicator = NO;
        self.stringCollectionView.scrollsToTop = NO;
        [self.contentView addSubview:self.stringCollectionView];
        
     }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.stringCollectionView.frame = self.contentView.bounds;
}

/*
- (void)prepareForReuse
{
}

- (void)dealloc
{
    NSLog(@"dealloc string table view cell");
}
 */



#pragma mark - Public

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.stringCollectionView.dataSource = dataSourceDelegate;
    self.stringCollectionView.delegate = dataSourceDelegate;
    self.stringCollectionView.index = index;
    
    [self.stringCollectionView reloadData];
}

/*
- (void)setCollectionData:(NSArray *)collectionData
{
    [_stringCollectionView setCollectionData:[collectionData mutableCopy]];
}
 */

/*
- (void)setStringObject:(PFObject *)string
{
    [_stringView setStringObject:string];
}

- (void)setStringViewDelegate:(id<StringViewDelegate>)delegate
{
    [_stringView setDelegate:delegate];
}

- (void)queryPhotosFromQuery:(PFQuery *)query
{
    [_stringView queryPhotosFromQuery:query];
}

- (void)reloadString
{
    [_stringView reloadString];
}
*/

#pragma mark - Private

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
