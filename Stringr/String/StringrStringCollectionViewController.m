//
//  StringrStringCollectionViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/13/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringCollectionViewController.h"

#import "StringCollectionViewCell.h"
#import "StringrPhotoViewerViewController.h"

@interface StringrStringCollectionViewController ()

@property (strong, nonatomic) NSArray *images;

@end

@implementation StringrStringCollectionViewController

#pragma mark - Lifecycle

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
	
    // Test string array/dictionaries
    self.images = @[ @{ @"title": @"Article A1", @"image":@"sample_1.jpeg" },
                     @{ @"title": @"Article A2", @"image":@"sample_2.jpeg" },
                     @{ @"title": @"Article A3", @"image":@"sample_3.jpeg" },
                     @{ @"title": @"Article A4", @"image":@"sample_4.jpeg" },
                     @{ @"title": @"Article A5", @"image":@"sample_5.jpeg" }
                  ];
    UIColor *collectionViewBGColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    [self.collectionView setBackgroundColor:collectionViewBGColor];
}




#pragma  mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        StringCollectionViewCell *imageCell = (StringCollectionViewCell *)cell;
        
        NSDictionary *stringData = [self.images objectAtIndex:indexPath.item];
        
        [imageCell.cellTitle setText:@""];
        
        UIImage *cellImage = [UIImage imageNamed:[stringData objectForKey:@"image"]];
        [imageCell.cellImage setImage:cellImage];
        
        return imageCell;
    }
    
    return cell;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringrPhotoViewerViewController *photoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerVC"];
    
    NSDictionary *stringData = [self.images objectAtIndex:indexPath.item];
    [photoVC setPhotoViewerImage:[UIImage imageNamed:[stringData objectForKey:@"image"]]];
    
    [self.navigationController pushViewController:photoVC animated:YES];
}

@end
