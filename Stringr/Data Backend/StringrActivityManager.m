//
//  StringrActivityManager.m
//  Stringr
//
//  Created by Jonathan Howard on 10/5/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrActivityManager.h"

@interface StringrActivityManager ()

@property (nonatomic) NSInteger numberOfPreviousActivities;
@property (nonatomic) NSInteger numberOfActivities;

@end

@implementation StringrActivityManager

+ (instancetype)sharedManager
{
    static StringrActivityManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kStringrInstallationNumberOfPreviousActivitiesKey]) {
            _numberOfPreviousActivities = [[[NSUserDefaults standardUserDefaults] objectForKey:kStringrInstallationNumberOfPreviousActivitiesKey] integerValue];
        }
        else {
            _numberOfPreviousActivities = 0;
        }
    }
    
    return self;
}


- (NSInteger)numberOfNewActivitiesForCurrentUser
{
    NSInteger numberOfNewActivities = self.numberOfActivities - self.numberOfPreviousActivities;
    self.numberOfPreviousActivities = self.numberOfActivities;
    
    if (numberOfNewActivities > 0) {
        return numberOfNewActivities;
    }
    
    return 0;
}


- (void)setNumberOfActivitiesForCurrentUser:(NSInteger)numberOfActivities
{
    self.numberOfActivities = numberOfActivities;
    [self updateUserDefaults];
}


- (void)updateUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.numberOfActivities) forKey:kStringrInstallationNumberOfPreviousActivitiesKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUserHasNewActivities" object:nil];
}


@end
