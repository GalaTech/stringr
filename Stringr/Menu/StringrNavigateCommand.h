//
//  StringrNavigateCommand.h
//  Stringr
//
//  Created by Jonathan Howard on 12/7/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringrNavigateCommand : NSObject

@property (copy, nonatomic) void(^segmentDisplayBlock)(UIViewController *);

@property (nonatomic) Class viewControllerClass;
@property (strong, nonatomic) UIViewController *viewController;
@property (weak, nonatomic) id delegate;

- (instancetype)initWithViewControllerClass:(Class)class delegate:(id)delegate NS_DESIGNATED_INITIALIZER;

- (void)execute;

@end
