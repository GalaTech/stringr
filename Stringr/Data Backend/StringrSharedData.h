//
//  StringrSharedData.h
//  Stringr
//
//  Created by Jonathan Howard on 10/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrSharedData : NSObject

- (void)setup;

- (void)setNumberOfActivitiesForCurrentUser:(NSInteger)numberOfActivities;
- (NSInteger)numberOfActivitiesForCurrentUser;

@end

@interface UIApplication (StringrSharedData)

+ (StringrSharedData *)sharedData;

@end