//
//  StringrWriteAndEditTextViewController.h
//  Stringr
//
//  Created by Jonathan Howard on 4/10/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StringrWrittenTextTypeStandard,
    StringrWrittenTextTypeEmail,
    StringrWrittenTextTypePassword
} StringrWrittenTextType;

@protocol StringrWriteAndEditTextViewControllerDelegate <NSObject>

@optional

- (void)reloadTextAtIndexPath:(NSIndexPath *)indexPath withText:(NSString *)text;
- (void)textWrittenAndSavedByUser:(NSString *)text withType:(StringrWrittenTextType)textType;

@end

@interface StringrWriteAndEditTextViewController : UIViewController

@property (weak, nonatomic) id<StringrWriteAndEditTextViewControllerDelegate> delegate;

- (void)setTextForEditing:(NSString *)text;

@end

