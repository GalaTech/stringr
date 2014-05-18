//
//  StringCollectionViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringCollectionViewCell : UICollectionViewCell

/**
 * This image view fills the entire frame of the collection view cell. It has autolyaout applied
 * so that it will dynamically increase no matter the size of the image it contains. The image will
 * generally be of type PFObject, which will be loaded asynchronously into the image view. 
 */
@property (weak, nonatomic) IBOutlet PFImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingImageIndicator;

@end
