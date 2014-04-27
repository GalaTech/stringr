//
//  StringrInviteUserTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 4/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrInviteUserTableViewCell : UITableViewCell

- (void)setUserToInviteDisplayName:(NSString *)name;
//- (void)setUserToInviteProfileImage:(UIImage *)image;
- (void)setUserToInviteProfileImageURL:(NSURL *)url;

@end
