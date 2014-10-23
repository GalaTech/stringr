//
//  StringrLikedTabBarViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrLikedTabBarViewController.h"
#import "UIColor+StringrColors.h"

@interface StringrLikedTabBarViewController ()

@end

@implementation StringrLikedTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setTintColor:[UIColor stringrLogoPurpleColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
