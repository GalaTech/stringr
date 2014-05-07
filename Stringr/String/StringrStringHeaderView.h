//
//  StringrStringHeaderView.h
//  Stringr
//
//  Created by Jonathan Howard on 5/6/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrStringHeaderViewDelegate;

@interface StringrStringHeaderView : UIView

@property (nonatomic) NSUInteger section;
@property (strong, nonatomic) PFObject *stringForHeader;
@property (nonatomic) BOOL stringEditingEnabled;
@property (strong, nonatomic) id<StringrStringHeaderViewDelegate> delegate;

@end


@protocol StringrStringHeaderViewDelegate <NSObject>

- (void)headerView:(StringrStringHeaderView *)headerView pushToStringDetailViewWithString:(PFObject *)string;

@end