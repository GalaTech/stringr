//
//  StringrMyStringsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMyStringsTableViewController.h"
#import "StringrStringDetailViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrNavigationController.h"
#import "StringCollectionView.h"

@interface StringrMyStringsTableViewController () <UIActionSheetDelegate, StringrPhotoDetailEditTableViewControllerDelegate>

@property (nonatomic) BOOL editingStringsEnabled;

@end

@implementation StringrMyStringsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"My Strings";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(pushToStringEdit:)];
	self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editedStringSuccessfully) name:kNSNotificationCenterStringPublishedSuccessfully object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editedStringSuccessfully) name:kNSNotificationCenterStringDeletedSuccessfully object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterStringPublishedSuccessfully object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterStringDeletedSuccessfully object:nil];
}



#pragma mark - Private

- (void)editedStringSuccessfully
{
    [self loadObjects];
}


- (void)configureHeader:(StringrStringHeaderView *)headerView forSection:(NSUInteger)section withString:(PFObject *)string
{
    headerView.section = section;
    headerView.stringForHeader = string;
    headerView.stringEditingEnabled = self.editingStringsEnabled;
    headerView.delegate = self;
}

- (void)reloadHeaders {
    for (NSInteger i = 0; i < [self numberOfSectionsInTableView:self.tableView]; i++) {
        StringrStringHeaderView *header = (StringrStringHeaderView *)[self.tableView headerViewForSection:i];
        PFObject *string = header.stringForHeader;
        [self configureHeader:header forSection:i withString:string];
    }
}



#pragma mark - Actions

// Handles the action of moving a user to edit the selected string.
// This will eventually incorporate the selection of a specific string and then taking the user
// to edit that string individually
- (void)pushToStringEdit:(UIBarButtonItem *)sender
{
    if (!self.editingStringsEnabled) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushToStringEdit:)];
        
        self.editingStringsEnabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(pushToStringEdit:)];
        self.editingStringsEnabled = NO;
    }
    
    [self reloadHeaders];
}



#pragma mark - UICollectionView Delegate

- (void)collectionView:(StringCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *stringPhotos = self.stringPhotos[collectionView.index];
    
    if (stringPhotos) {
        
        if (self.editingStringsEnabled) {
            StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            
            [photoDetailVC setEditDetailsEnabled:YES];
            
            // Sets the photos to be displayed in the photo pager
            [photoDetailVC setPhotosToLoad:stringPhotos];
            [photoDetailVC setSelectedPhotoIndex:indexPath.item];
            [photoDetailVC setStringOwner:self.objects[collectionView.index]];
            [photoDetailVC setDelegateForPhotoController:self]; // to delete from string directly
            
            [photoDetailVC setHidesBottomBarWhenPushed:YES];
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:photoDetailVC];
            
            [self presentViewController:navVC animated:YES completion:nil];
        } else {
            StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            
            [photoDetailVC setEditDetailsEnabled:NO];
            
            // Sets the photos to be displayed in the photo pager
            [photoDetailVC setPhotosToLoad:stringPhotos];
            [photoDetailVC setSelectedPhotoIndex:indexPath.item];
            [photoDetailVC setStringOwner:self.objects[collectionView.index]];
            
            [photoDetailVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:photoDetailVC animated:YES];
        }

    }
}



#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *myStringsQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    [myStringsQuery whereKey:kStringrStringUserKey equalTo:[PFUser currentUser]];
    [myStringsQuery orderByDescending:@"createdAt"];
    
    return myStringsQuery;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"You haven't uploaded any Strings!"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Upload your first String"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
}



#pragma mark - StringrStringHeaderView Delegate

- (void)headerView:(StringrStringHeaderView *)headerView tappedHeaderInSection:(NSUInteger)section withString:(PFObject *)string
{
    if (self.editingStringsEnabled) {
        StringrStringDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        
        if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
            string = [string objectForKey:kStringrStatisticsStringKey];
        } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
            string = [string objectForKey:kStringrActivityStringKey];
        }
        
        // tag is set to the section number of each string
        [detailVC setStringToLoad:string];
        [detailVC setEditDetailsEnabled:YES];
        [detailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        StringrStringDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        
        if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
            string = [string objectForKey:kStringrStatisticsStringKey];
        } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
            string = [string objectForKey:kStringrActivityStringKey];
        }
        
        // tag is set to the section number of each string
        [detailVC setStringToLoad:string];
        [detailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}



#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    [self addNewString];
}

@end
