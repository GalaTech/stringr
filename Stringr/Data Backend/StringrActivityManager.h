//
//  StringrActivityManager.h
//  Stringr
//
//  Created by Jonathan Howard on 10/5/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrActivityManager : NSObject

+ (instancetype)sharedManager;

- (NSInteger)numberOfNewActivitiesForCurrentUser;
- (void)setNumberOfActivitiesForCurrentUser:(NSInteger)numberOfActivities;

@end
