//
//  StringrStringTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringTopEditViewController.h"
#import "StringrFooterView.h"

@interface StringrStringTopEditViewController ()

@end

@implementation StringrStringTopEditViewController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static float const contentViewWidth = 320.0;
static float const contentViewHeight = 41.5;
static float const contentFooterViewWidthPercentage = .93;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [StringrConstants kStringTableViewBackgroundColor];
    
    //float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
    //GRect footerRect = CGRectMake(footerXLocation, 241, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
    //StringrFooterView *contentFooterView = [[StringrFooterView alloc] initWithFrame:footerRect withFullWidthCell:NO];
    
    //[self.view addSubview:contentFooterView];
}


@end
