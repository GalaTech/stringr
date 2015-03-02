//
//  StringrNavigateCommand.h
//  Stringr
//
//  Created by Jonathan Howard on 12/7/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StringrContainerScrollViewDelegate;

@interface StringrNavigateCommand : NSObject

@property (strong, nonatomic) void(^segmentDisplayBlock)(UIViewController <StringrContainerScrollViewDelegate>*);

@property (nonatomic) Class viewControllerClass;
@property (strong, nonatomic) UIViewController <StringrContainerScrollViewDelegate>*viewController;
@property (weak, nonatomic) id delegate;

- (instancetype)initWithViewControllerClass:(Class)class delegate:(id)delegate NS_DESIGNATED_INITIALIZER;

- (void)execute;

@end
