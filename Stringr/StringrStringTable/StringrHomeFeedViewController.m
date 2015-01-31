//
//  StringrFollowingTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 5/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrHomeFeedViewController.h"
#import "StringrContainerScrollViewDelegate.h"

@interface StringrHomeFeedViewController ()

@end

@implementation StringrHomeFeedViewController

#pragma mark - Lifecycle

+ (StringrHomeFeedViewController *)viewController
{
    StringrHomeFeedViewController *homeFeedVC = [StringrHomeFeedViewController new];
    homeFeedVC.dataType = StringrFollowingNetworkTask;
    return homeFeedVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = 90.0f;
    CGFloat height = width * (87.0f / 241.0f);
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIImageView *stringrImageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    stringrImageTitle.image = [UIImage imageNamed:@"stringr_logo"];
    
    [titleView addSubview:stringrImageTitle];
    
    self.navigationItem.titleView = titleView;
}


#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    [[UIApplication appDelegate].appViewController transitionToDashboardTabIndex:DashboardExploreIndex];
}

@end
