//
//  StringrLikedPhotosTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrLikedPhotosTableViewController.h"
#import "StringTableViewCell.h"
#import "StringrPhotoDetailViewController.h"
#import "NHBalancedFlowLayout.h"
#import "StringCollectionViewCell.h"
#import "UIColor+StringrColors.h"

@interface StringrLikedPhotosTableViewController () <NHBalancedFlowLayoutDelegate>

@property (strong, nonatomic) NSMutableArray *collectionViewLikedPhotos;

@end

@implementation StringrLikedPhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.parseClassName = kStringrPhotoClassKey;
        
        
        [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"cell_identifier"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Liked Photos";
    self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)getLikedPhotos
{
        self.collectionViewLikedPhotos = [[NSMutableArray alloc] init];
        
        for (PFObject *activityObject in self.objects) {
            PFObject *photo = [activityObject objectForKey:kStringrActivityPhotoKey];
            if (photo) {
                [self.collectionViewLikedPhotos addObject:[activityObject objectForKey:kStringrActivityPhotoKey]];
            }
            
            PFObject *string = [[activityObject objectForKey:kStringrActivityPhotoKey] objectForKey:kStringrPhotoStringKey];
            if (string) {
                [string fetchInBackgroundWithBlock:nil];
            }
        }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.objects.count > 0) {
        return 1;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_identifier";

    StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!stringCell) {
        stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [stringCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return stringCell;
}



#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(StringTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.section];
}


#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *likePhotosActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likePhotosActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likePhotosActivityQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [likePhotosActivityQuery whereKeyExists:kStringrActivityPhotoKey];
    [likePhotosActivityQuery includeKey:kStringrActivityPhotoKey];
    [likePhotosActivityQuery orderByDescending:@"createdAt"];
    [likePhotosActivityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    
    return likePhotosActivityQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"You do not have any liked Photos"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Explore Photos to Like"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
        [self getLikedPhotos];
    }
}

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
}




#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewLikedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StringCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        
        PFObject *photo = self.collectionViewLikedPhotos[indexPath.item];
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        
        if (photo) {
            [stringCell.loadingImageIndicator setHidden:NO];
            [stringCell.loadingImageIndicator startAnimating];
            
            if ([photo isKindOfClass:[PFObject class]]) {
                PFObject *photoObject = (PFObject *)photo;
                
                PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
                [stringCell.cellImage setFile:imageFile];
                
                [stringCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
                    [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
                    [stringCell.loadingImageIndicator stopAnimating];
                    [stringCell.loadingImageIndicator setHidden:YES];
                }];
            }
        }
        
        return stringCell;
    } else {
        return nil;
    }
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(StringCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionViewLikedPhotos) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StringrPhotoDetailViewController *photoDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:self.collectionViewLikedPhotos];
        [photoDetailVC setSelectedPhotoIndex:indexPath.item];
        [photoDetailVC setStringOwner:nil];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
    
}



#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(StringCollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id photo = self.collectionViewLikedPhotos[indexPath.item];
    
    NSNumber *width = 0;
    NSNumber *height = 0;
    
    if ([photo isKindOfClass:[PFObject class]]) {
        PFObject *photoObject = (PFObject *)photo;
        
        width = [photoObject objectForKey:kStringrPhotoPictureWidth];
        height = [photoObject objectForKey:kStringrPhotoPictureHeight];
    } else if ([photo isKindOfClass:[UIImage class]]) {
        UIImage *photoImage = (UIImage *)photo;
        
        width = [NSNumber numberWithInt:photoImage.size.width];
        height = [NSNumber numberWithInt:photoImage.size.height];
    }
    
    
    return CGSizeMake([width floatValue], [height floatValue]);
}



#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [StringrDiscoveryTabBarViewController new];
    [discoveryTabBarVC setSelectedIndex:1]; // sets the selected tab to Discovery
    
    // need to deep link to explore content
}

@end
