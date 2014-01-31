//  StringrStringCollectionViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/13/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringCollectionViewController.h"
#import "StringCollectionViewCell.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrNavigationController.h"
#import "UIImage+Decompression.h"

@interface StringrStringCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *images;

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

static int const NUMBER_OF_IMAGES = 24;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:kUserDefaultsWorkingStringSavedImagesKey]) {
        NSArray *tempDefaultsImagesArray = [defaults arrayForKey:kUserDefaultsWorkingStringSavedImagesKey];
        self.images = [[NSMutableArray alloc] initWithArray:tempDefaultsImagesArray];
        
    } else {
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
            NSString *imageName = [NSString stringWithFormat:@"photo-%02d.jpg", i];
            
            NSDictionary *photo = @{@"title": @"Article A1", @"image": imageName};
            
            [images addObject:photo];
        }
        self.images = [images mutableCopy];
        
        /*
        self.images = [[NSMutableArray alloc] initWithArray:@[ @{ @"title": @"Article A1", @"image":@"sample_1.jpeg" },
                                                           @{ @"title": @"Article A2", @"image":@"sample_2.jpeg" },
                                                           @{ @"title": @"Article A3", @"image":@"sample_3.jpeg" },
                                                           @{ @"title": @"Article A4", @"image":@"sample_4.jpeg" },
                                                           @{ @"title": @"Article A5", @"image":@"sample_5.jpeg" }
                                                           ]];
         */
        
        [defaults setObject:self.images forKey:kUserDefaultsWorkingStringSavedImagesKey];
        [defaults synchronize];
    }
    
    
    [self.collectionView setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserDefaultsWorkingStringSavedImagesKey];
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
    
    /*
    // Uses a secondary thread for loading the images into the collectionView for lag free experience
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *cellImage = [UIImage decodedImageWithImage:[UIImage imageNamed:[cellData objectForKey:@"image"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:stringCell];
            if (currentIndexPathForCell.row == rowIndex) {
                [stringCell.cellImage setImage:cellImage];
            }
        });
        
        
    });
    
    */
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        StringCollectionViewCell *imageCell = (StringCollectionViewCell *)cell;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            NSDictionary *stringData = [self.images objectAtIndex:indexPath.item];
            UIImage *cellImage = [UIImage imageNamed:[stringData objectForKey:@"image"]];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                //[imageCell.cellTitle setText:nil];
                
                [imageCell.cellImage setImage:cellImage];
                
                // Sets the cells image to aspect fill the cell so the image is not stretched/compressed
                [imageCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
            });
        });
        
        
        
        return imageCell;
    }
    
    return cell;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
    
    [photoDetailVC setDetailsEditable:YES];
    NSDictionary *stringData = [self.images objectAtIndex:indexPath.item];
    [photoDetailVC setCurrentImage:[UIImage imageNamed:[stringData objectForKey:@"image"]]];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:photoDetailVC];
    
    
    [self presentViewController:navVC animated:YES completion:nil];
    //[self.navigationController pushViewController:photoDetailVC animated:YES];
}




#pragma mark - ReorderableCollectionView DataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSDictionary *stringImage = [self.images objectAtIndex:fromIndexPath.item];
    
    [self.images removeObjectAtIndex:fromIndexPath.item];
    [self.images insertObject:stringImage atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}




#pragma mark - ReorderableCollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.images forKey:kUserDefaultsWorkingStringSavedImagesKey];
    [defaults synchronize];
}



@end
