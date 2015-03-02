//
//  STGRNetworkTaskConfiguration.h
//  Stringr
//
//  Created by Jonathan Howard on 2/28/15.
//  Copyright (c) 2015 Stringr LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StringrUserType = 0,
    StringrStringType,
    StringrPhotoType,
    StringrCommentType,
    StringrFollowType,
    StringrLikeType,
    StringrContributedType,
    StringrMentionType,
    StringrNoType
} STGRNetworkType;

@interface STGRNetworkTaskConfiguration : NSObject

@property (nonatomic) STGRNetworkType networkType;
@property (strong, nonatomic) PFUser *user;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger skip;


@end
