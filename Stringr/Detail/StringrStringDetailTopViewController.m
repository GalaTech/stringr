//
//  StringrStringTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTopViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrFooterView.h"

@interface StringrStringDetailTopViewController ()

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringView *stringCollectionView;

@end

@implementation StringrStringDetailTopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _stringCollectionView = [[NSBundle mainBundle] loadNibNamed:@"StringLargeCollectionView" owner:self options:nil][0];
    _stringCollectionView.frame = self.stringView.bounds;
    [_stringCollectionView setStringObject:self.stringToLoad];
    [_stringCollectionView setDelegate:self];
    
    //[_stringCollectionView setCollectionData:[self.stringPhotoData mutableCopy]];
    [self.stringView addSubview:_stringCollectionView];
    
    self.view.backgroundColor = [StringrConstants kStringCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
 
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
 



#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the initial photo to the selected cell's PFObject photo data
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setStringOwner:string];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}

@end
