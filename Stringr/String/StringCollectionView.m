//
//  StringCollectionView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringCollectionView.h"
#import "StringCollectionViewCell.h"
#import "StringCollectionViewFlowLayout.h"

@interface StringCollectionView ()

@end

@implementation StringCollectionView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];

    // disables the embedded scroll views scroll to top so that when inside of
    // a table view it will allow you to truly scroll to top.
    [self setScrollsToTop:NO];
    
    [self setShowsHorizontalScrollIndicator:NO];
    
    StringCollectionViewFlowLayout *layout = [[StringCollectionViewFlowLayout alloc] init];
    
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.preferredRowSize = 320;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    [self setCollectionViewLayout:layout];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        
    }
    return self;
}



@end
