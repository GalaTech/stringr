//
//  StringrUserTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 11/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrPathImageView;

@interface StringrUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StringrPathImageView *ProfileThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDisplayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;

@end
