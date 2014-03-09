//
//  StringCollectionViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringCollectionViewCell : UICollectionViewCell

@property (weak) IBOutlet PFImageView *cellImage;
@property (weak) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingImageIndicator;

@end
