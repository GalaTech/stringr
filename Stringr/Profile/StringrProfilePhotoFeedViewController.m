//
//  StringrProfilePhotoFeedViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/19/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrProfilePhotoFeedViewController.h"

@interface StringrProfilePhotoFeedViewController ()

@end

@implementation StringrProfilePhotoFeedViewController

+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StringrPhotoCollectionStoryboard" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"StringrProfilePhotoFeedViewController"];
}


+ (instancetype)photoFeedWithDataType:(StringrNetworkPhotoTaskType)dataType user:(PFUser *)user
{
    StringrProfilePhotoFeedViewController *photoFeedVC = [StringrProfilePhotoFeedViewController viewController];
    photoFeedVC.modelController.user = user;
    photoFeedVC.modelController.dataType = dataType;
    
    return photoFeedVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.showsVerticalScrollIndicator = NO;
}


#pragma mark - 

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.bounds.size.width, 182.5f);
}


#pragma mark - <StringrContainerScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate containerViewDidScroll:scrollView];
}


- (void)adjustScrollViewTopInset:(CGFloat)inset
{
    
}


- (UIScrollView *)containerScrollView
{
    return self.collectionView;
}

@end
