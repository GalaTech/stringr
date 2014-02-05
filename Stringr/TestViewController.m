//
//  TestViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestViewController.h"
#import "StringCollectionView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"

@interface TestViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NHBalancedFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet StringCollectionView *collectionView;

@end

@implementation TestViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(170, 170);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    */
     
   // StringCollectionView *collectionView = [[StringCollectionView alloc] initWithFrame:CGRectMake(0, 50, 320, 170) collectionViewLayout:flowLayout];
    
    //[self.view addSubview:collectionView];
    //self.collectionView = collectionView;
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - UICollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.item % 2 == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        UIImage *cellImage = [UIImage imageNamed:@"alonsoAvatar.jpg"];
        [stringCell.cellImage setImage:cellImage];
        
        return stringCell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        UIImage *cellImage = [UIImage imageNamed:@"photo-01.jpg"];
        [stringCell.cellImage setImage:cellImage];
        
        return stringCell;
    }

    
    // Creates a new cell for the collection view using the reusable cell identifier
    //StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    
    // Gets the cell at indexPath from our collection data, which will be images.
   // NSDictionary *cellData = [self.stringImages objectAtIndex:[indexPath row]];
    // Sets the title for the cell
    //stringCell.cellTitle.text = [cellData objectForKey:@"title"];
    

    
    //UIImage *cellImage = [UIImage imageNamed:[cellData objectForKey:@"image"]];
    //stringCell.cellImage.image = cellImage;
    
    return cell;
}


#pragma mark - UICollectionView Delegate



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSDictionary *photoDictionary = [self.collectionData objectAtIndex:indexPath.item];
    //UIImage *image = [UIImage imageNamed:[photoDictionary objectForKey:@"image"]];
    
    UIImage *cellImage = [UIImage imageNamed:@"alonsoAvatar.jpg"];
    
    return [cellImage size];
}


@end
