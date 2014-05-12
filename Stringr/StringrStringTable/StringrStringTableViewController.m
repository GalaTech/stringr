//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrNavigationController.h"

#import "StringrPhotoDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

#import "StringrMyStringsTableViewController.h"
#import "StringrUserTableViewController.h"

#import "StringTableViewCell.h"
#import "StringrFooterView.h"

#import "StringrLoadMoreTableViewCell.h"

#import "StringrStringDetailViewController.h"

@interface StringrStringTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StringrFooterViewDelegate>

@property (strong, nonatomic) NSMutableArray *stringPhotos;

@end

@implementation StringrStringTableViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = kStringrStringClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 2;
    }
    
    return self;
}

- (void)dealloc
{
    [PFQuery clearAllCachedResults];
    NSLog(@"dealloc string table");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"disappear");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Private

- (StringrFooterView *)addFooterViewToCellWithObject:(PFObject *)object
{
    static float const contentViewWidth = 320.0;
    static float const contentViewHeight = 41.5;
    static float const contentFooterViewWidthPercentage = .93;
    
    float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
    CGRect footerRect = CGRectMake(footerXLocation, 0, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
    StringrFooterView *footerView = [[StringrFooterView alloc] initWithFrame:footerRect fullWidthCell:NO withObject:object];
    [footerView setDelegate:self];
    
    return footerView;
}

- (void)configureHeader:(StringrStringHeaderView *)headerView forSection:(NSUInteger)section withString:(PFObject *)string
{
    headerView.section = section;
    headerView.stringForHeader = string;
    headerView.delegate = self;
}




#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
    if (self.objects.count == self.objectsPerPage) {
        return self.objects.count + 1;
    }
     */
    
    return self.objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One of the rows is for the footer view
    return 2;
}





#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < self.objects.count) {
        return 23.5f;
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.objects.count) {
        StringrStringHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        
        if (!headerView) {
            headerView = [[StringrStringHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        }
        
        [self configureHeader:headerView forSection:section withString:[self.objects objectAtIndex:section]];

        return headerView;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.objects.count) {
        if (indexPath.row == 0) {
            // string view
            return 157.0f;
        } else if (indexPath.row == 1) {
            // footer view
            return 52.0f;
        }
    }
        
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell isKindOfClass:[StringTableViewCell class]]) {
        StringTableViewCell *stringCell = (StringTableViewCell *)cell;
        [stringCell reloadString];
    }
     
    
}



#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable
{
    PFQuery *query = [self getQueryForTable];
    query.limit = 100;
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    
    
    return query;
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFObject *string = object;
    
    //NSArray *photos = [self.stringPhotos objectAtIndex:indexPath.row];
    
    // It's possible for this object to be of type statistic or activity. This just gets the string
    // value from either of those classes
    if ([object.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [object objectForKey:kStringrStatisticsStringKey];
    } else if ([object.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [object objectForKey:kStringrActivityStringKey];
    }
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"StringTableViewCell";
        StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!stringCell) {
            stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [stringCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [stringCell setStringViewDelegate:self];
        [stringCell setStringObject:string];

        return stringCell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"StringTableViewFooter";
        
        UITableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!footerCell) {
            footerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [footerCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        [footerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        StringrFooterView *footerView = [self addFooterViewToCellWithObject:string];
        
        [footerCell.contentView addSubview:footerView];
        
        return footerCell;
    } else {
        return nil;
    }
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    // instantiates string photos with blank objects of count self.objects
    self.stringPhotos = [[NSMutableArray alloc] initWithCapacity:self.objects.count];
    for (int i = 0; i < self.objects.count; i++) {
        [self.stringPhotos addObject:@""];
    }
    
    // Querries all of the photos for the strings and puts them in an array
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *string = [self.objects objectAtIndex:i];
        
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:string];
        [stringPhotoQuery orderByAscending:@"photoOrder"]; // photoOrder: each photo has a number associated with where it falls into the string
        [stringPhotoQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if (!error) {
                [self.stringPhotos replaceObjectAtIndex:i withObject:photos];
                
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    // returns the object for every collection string and footer cell
    if (indexPath.section < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.section];
    } else {
        return nil;
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    //PFTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
    //[loadCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    StringrLoadMoreTableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
    
    if (!loadMoreCell) {
        loadMoreCell = [[StringrLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
    }
    
    return loadMoreCell;
}
 */




#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *stringPhotos = [self.stringPhotos objectAtIndex:section];
    
    return stringPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //PFObject *string = [self.objects objectAtIndex:indexPath.section];
    //NSArray *photos = [self.stringPhotos objectAtIndex:indexPath.section];
    
}




#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setStringOwner:string];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
        
    }
}



#pragma mark - StringrHeaderViewView Delegate

- (void)headerView:(StringrStringHeaderView *)headerView pushToStringDetailViewWithString:(PFObject *)string
{
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


#pragma mark - StringrFooterView Delegate

- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader
{
    if (uploader) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        
        [profileVC setUserForProfile:uploader];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        [profileVC setHidesBottomBarWhenPushed:YES];

        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object
{
    /*
    if (object) {
        if ([object.parseClassName isEqualToString:kStringrStringClassKey]) {
            [StringrUtility likeStringInBackground:object block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [footerView refreshLikesAndComments];
                }
            }];
        } else if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            [StringrUtility likePhotoInBackground:object block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [footerView refreshLikesAndComments];
                }
            }];
        }
    }
     */
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object
{
    if (object) {
        StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:object];
        
        NSString *forObjectKey = kStringrActivityStringKey;
        
        if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            forObjectKey = kStringrActivityPhotoKey;
        }
        
        PFQuery *query = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [query whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
        [query whereKey:forObjectKey equalTo:object];
        [query whereKeyExists:kStringrActivityFromUserKey];
        [query orderByDescending:@"createdAt"];
        [commentsVC setQueryForTable:query];
        
        [commentsVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}


@end
