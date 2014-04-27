//
//  StringrLikedPhotosTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/25/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrLikedPhotosTableViewController.h"
#import "StringView.h"
#import "StringTableViewCell.h"
#import "StringrPhotoDetailViewController.h"

@interface StringrLikedPhotosTableViewController () <StringViewDelegate>

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
    self.tableView.backgroundColor = [StringrConstants kStringTableViewBackgroundColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_identifier";

    StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!stringCell) {
        stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [stringCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [stringCell setStringViewDelegate:self];
    
    PFQuery *likePhotosActivityQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likePhotosActivityQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likePhotosActivityQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [likePhotosActivityQuery whereKeyExists:kStringrActivityPhotoKey];
    [likePhotosActivityQuery includeKey:kStringrActivityPhotoKey];
    [likePhotosActivityQuery orderByAscending:@"createdAt"];
    [likePhotosActivityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [stringCell queryPhotosFromQuery:likePhotosActivityQuery];
    
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




#pragma mark - PFQueryTableViewController Delegate

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
    [self.tableView reloadData];
}




#pragma mark - StringrView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        StringrPhotoDetailViewController *photoDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setStringOwner:nil];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
        
    }
}

@end
