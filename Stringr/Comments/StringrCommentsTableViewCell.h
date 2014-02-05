//
//  StringrCommentsTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 1/31/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrPathImageView.h"

@interface StringrCommentsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StringrPathImageView *commentsProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *commentsProfileDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *commentsUploadDateTime;
@property (weak, nonatomic) IBOutlet UILabel *commentsTextComment;

@end
