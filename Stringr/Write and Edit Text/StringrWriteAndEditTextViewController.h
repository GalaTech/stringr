//
//  StringrWriteAndEditTextViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 4/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrWriteAndEditTextViewControllerDelegate;

@interface StringrWriteAndEditTextViewController : UIViewController

@property (strong, nonatomic) id<StringrWriteAndEditTextViewControllerDelegate> delegate;

- (void)setTextForEditing:(NSString *)text;

@end

@protocol StringrWriteAndEditTextViewControllerDelegate <NSObject>

- (void)reloadTextAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text;

@end