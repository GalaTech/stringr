//
//  StringrSetProfileDescriptionTableViewCell.h
//  Stringr
//
//  Created by Jonathan Howard on 3/4/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrSetProfileDescriptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *setProfileDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCharactersRemainingLabel;

@end
