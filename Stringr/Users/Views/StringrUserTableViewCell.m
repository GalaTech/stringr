//
//  StringrUserTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 11/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewCell.h"


@implementation StringrUserTableViewCell

/** Allows you to initialize a cell with the users profile thumbnail image and all accompanying information.
 *
 * @param profileImage The thumbnail image for a users profile
 * @param displayName The display name for a users profile
 * @param universityName The university name for a users profile
 * @param numberOfStrings The number of strings a user has uploaded
 *
 */
- (id)initWithProfileImage:(UIImage *)profileImage displayName:(NSString *)displayName universityName:(NSString *)universityName numberOfUserStrings:(NSUInteger)numberOfStrings
{
    
    self = [super init];
    
    if (self) {
        self.profileThumbnailImage = profileImage;
        self.profileDisplayName = displayName;
        self.profileUniversityName = universityName;
        self.profileNumberOfStrings = numberOfStrings;
    }
    
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
