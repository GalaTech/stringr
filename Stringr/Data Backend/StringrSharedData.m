//
//  StringrSharedData.m
//  Stringr
//
//  Created by Jonathan Howard on 10/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrSharedData.h"

@interface StringrSharedData ()

@property (nonatomic) NSInteger numberOfActivities;

@end

@implementation StringrSharedData

+ (StringrSharedData *)sharedData
{
    static StringrSharedData *sharedData;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedData = [[self alloc] init];
    });
    
    return sharedData;
}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _numberOfActivities = 0;
    }
    
    return self;
}


#pragma mark - Public

- (void)setup
{
    
}


- (void)setNumberOfActivitiesForCurrentUser:(NSInteger)numberOfActivities
{
    
}


- (NSInteger)numberOfActivitiesForCurrentUser
{
    return 0;
}


#pragma mark - Private


@end
