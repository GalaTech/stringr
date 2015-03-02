//
//  StringrUserStringFeedViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/31/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrUserStringFeedViewController.h"

@interface StringrUserStringFeedViewController ()

@end

@implementation StringrUserStringFeedViewController

#pragma mark - Lifecycle

+ (instancetype)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType user:(PFUser *)user
{
    StringrUserStringFeedViewController *userStringFeedVC = [StringrUserStringFeedViewController new];
    userStringFeedVC.modelController.userForFeed = user;
    userStringFeedVC.modelController.dataType = taskType;
    
    return userStringFeedVC;
}


@end
