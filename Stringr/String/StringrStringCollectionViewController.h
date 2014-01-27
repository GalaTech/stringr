//
//  StringrStringCollectionViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/13/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringCollectionViewFlowLayout.h"
#import "StringReorderableCollectionViewFlowLayout.h"


@interface StringrStringCollectionViewController : UICollectionViewController<StringReorderableCollectionViewFlowLayoutDataSource, StringReorderableCollectionViewFlowLayoutDelegate>

@end
