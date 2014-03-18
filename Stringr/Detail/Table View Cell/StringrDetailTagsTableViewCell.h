//
//  StringrDetailTagsTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrDetailTagsTableViewCell : UITableViewCell

/**
 * Set the tags as individual tag tokens inside of the cell view.
 * This will insert a scroll view that is the width of the total tag size.
 * The user will be able to scroll horizontally through all of the tags so view them.
 *
 * @param tags The array of strings, which are tags. Each string is considered to be one tag. 
 */
- (void)setTagsFromArray:(NSArray *)tags;


- (void)setTagsForCell:(NSString *)tags;

@end
