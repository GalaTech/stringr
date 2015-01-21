//
//  StringrConfig.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrConfig : NSObject

@property (nonatomic, readonly) BOOL isFirstLaunch;
@property (nonatomic, getter = isDebugMode) BOOL debugMode;

+ (StringrConfig *)sharedConfig;

@end
