//
//  StringEditCollectionView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringEditCollectionView.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@implementation StringEditCollectionView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    self.scrollsToTop = NO;
    [self setShowsHorizontalScrollIndicator:NO];
    [self setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
    
    LXReorderableCollectionViewFlowLayout *reorderableFlowLayout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    [reorderableFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [reorderableFlowLayout setMinimumLineSpacing:0];
    [reorderableFlowLayout setMinimumInteritemSpacing:0];
    [reorderableFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [reorderableFlowLayout setItemSize:CGSizeMake(219, 219)];
    [self setCollectionViewLayout:reorderableFlowLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
