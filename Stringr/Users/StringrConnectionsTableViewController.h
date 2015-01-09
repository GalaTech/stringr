//
//  StringrUserConnectionsTableViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUserTableViewController.h"
#import "StringrViewController.h"

typedef enum {
    UserConnectionFollowingType = 0,
    UserConnectionFollowersType
} UserConnectionType;

@interface StringrConnectionsTableViewController : StringrTableViewController <StringrViewController>

@property (strong, nonatomic) PFUser *userForConnections;
@property (nonatomic) UserConnectionType connectionType;

@end
