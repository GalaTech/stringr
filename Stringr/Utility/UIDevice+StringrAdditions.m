//
//  UIDevice+StringrAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "UIDevice+StringrAdditions.h"

@implementation UIDevice (StringrAdditions)

- (BOOL)isAtLeastiOS8
{
    return [NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)];
}

@end
