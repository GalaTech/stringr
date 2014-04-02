//
//  StringrDetailTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "StringrFooterView.h"
#import "StringrDetailTitleTableViewCell.h"
#import "StringrDetailDescriptionTableViewCell.h"
#import "StringrDetailPhotoOwnerTableViewCell.h"

@interface StringrDetailTableViewController : UITableViewController<QMBParallaxScrollViewHolder, StringrFooterViewDelegate>

@property (strong, nonatomic) NSArray *sectionHeaderTitles;
@property (nonatomic) BOOL editDetailsEnabled;

@end
