//
//  StringrStringHeaderView.h
//  Stringr
//
//  Created by Jonathan Howard on 5/6/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StringrStringHeaderView;

@protocol StringrStringHeaderViewDelegate;

@interface StringrStringHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) PFObject *stringForHeader;
@property (nonatomic) NSUInteger section;
@property (nonatomic) BOOL stringEditingEnabled; // default is NO
@property (weak, nonatomic) id<StringrStringHeaderViewDelegate> delegate;

@end


@protocol StringrStringHeaderViewDelegate <NSObject>

/**
 * Tells the delegate that the header view was tapped at a specific section index.
 * @param headerView The header view object that is notifying you of the tapping.
 * @param section The section index of the header view that was selected.
 * @param string The string object that is being represented at the selected header view section.
 */
- (void)headerView:(StringrStringHeaderView *)headerView tappedHeaderInSection:(NSUInteger)section withString:(PFObject *)string;

@end


