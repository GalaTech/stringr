//
//  StringrUserTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 11/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrPathImageView.h"

@interface StringrUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StringrPathImageView *ProfileThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDisplayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNumberOfStringsLabel;

/*
@property (strong, nonatomic) NSString *profileDisplayName;
@property (strong, nonatomic) UIImage *profileThumbnailImage;
@property (strong, nonatomic) NSString *profileUniversityName;
@property (nonatomic) NSUInteger profileNumberOfStrings;
*/

/*
- (id)initWithProfileImage:(UIImage *)profileImage
               displayName:(NSString *)displayName
            universityName:(NSString *)universityName
       numberOfUserStrings:(NSUInteger)numberOfStrings;
*/


@end
