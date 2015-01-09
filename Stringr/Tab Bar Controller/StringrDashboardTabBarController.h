//
//  StringrHomeTabBarViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DashboardHomeIndex = 0,
    DashboardExploreIndex,
    DashboardCameraIndex,
    DashboardActivityIndex,
    DashboardProfileIndex
} DashboardTabIndex;

@interface StringrDashboardTabBarController : UITabBarController

- (void)setDashboardTabIndex:(DashboardTabIndex)index;

@end
