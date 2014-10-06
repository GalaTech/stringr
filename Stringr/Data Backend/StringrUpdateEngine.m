//
//  StringrUpdateEngine.m
//  Stringr
//
//  Created by Jonathan Howard on 10/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrUpdateEngine.h"
#import "StringrNetworkTask+Activity.h"

@interface StringrUpdateEngine ()

@property (strong, nonatomic) NSTimer *autoRefreshTimer;
@property (nonatomic) NSTimeInterval autoRefreshSeconds;

@end

@implementation StringrUpdateEngine

+ (instancetype)sharedEngine
{
    static StringrUpdateEngine *sharedInstance = nil;
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
        _autoRefreshSeconds = 30;
    }
    
    return self;
}


#pragma mark - Timer

- (void)setupAutoRefreshTimer
{
    [self.autoRefreshTimer invalidate];
    self.autoRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoRefreshSeconds target:self selector:@selector(refreshAll) userInfo:nil repeats:YES];
}


#pragma mark - Public

- (void)start
{
    [self setupAutoRefreshTimer];
    
    [[StringrUpdateEngine sharedEngine] refreshAll];
}


- (void)stop
{
    [self.autoRefreshTimer invalidate];
    self.autoRefreshTimer = nil;
}


- (void)refreshAll
{
    [StringrNetworkTask numberOfActivitesForUser:[PFUser currentUser] completionBlock:nil];
}


@end
