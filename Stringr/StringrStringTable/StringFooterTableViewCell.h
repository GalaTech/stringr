//
//  StringFooterTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 12/23/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringFooterTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *stringUploaderName;
@property (strong, nonatomic) UIImage *stringUploaderProfileImage;

@property (strong, nonatomic) NSString *stringUploadDate;

@property (strong, nonatomic) NSString *commentButtonTitle;
@property (strong, nonatomic) NSString *likeButtonTitle;



@end
