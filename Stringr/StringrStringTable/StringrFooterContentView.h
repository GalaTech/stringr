//
//  StringrFooterContentView.h
//  Stringr
//
//  Created by Jonathan Howard on 12/24/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPathImageView.h"

@interface StringrFooterContentView : UIView

@property (strong, nonatomic) IBOutlet GBPathImageView *footerProfileImage;

- (IBAction)testSwitch:(UISwitch *)sender;


@end
