//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrNavigationController.h"
#import "StringrStringDetailViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewController.h"
#import "StringrMyStringsTableViewController.h"
#import "StringrUserTableViewController.h"
#import "StringTableViewCell.h"
#import "StringCollectionViewCell.h"
#import "StringrFooterView.h"
#import "StringrLoadMoreTableViewCell.h"
#import "NHBalancedFlowLayout.h"

#import "TestTableViewHeader.h"

static NSString * const StringrStringTableViewControllerStoryboard = @"StringTable";

@interface StringrStringTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StringrFooterViewDelegate, NHBalancedFlowLayoutDelegate, StringrCommentsTableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation StringrStringTableViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

+ (StringrStringTableViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrStringTableViewControllerStoryboard bundle:nil];
    
    return (StringrStringTableViewController *)[storyboard instantiateViewControllerWithIdentifier:StringrStringTableViewControllerStoryboard];
}


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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterRefreshStringDetails object:nil];
    NSLog(@"dealloc string table");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StringTableViewFooter"];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStringDetails) name:kNSNotificationCenterRefreshStringDetails object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


//*********************************************************************************/
#pragma mark - Action Handlers
//*********************************************************************************/

- (void)refreshStringDetails
{
    NSIndexPath *stringDetailsIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *stringDetailsCell = [self.tableView cellForRowAtIndexPath:stringDetailsIndexPath];
    
    for (UIView *detailsCellSubview in stringDetailsCell.contentView.subviews) {
        if ([detailsCellSubview isKindOfClass:[StringrFooterView class]]) {
            StringrFooterView *stringDetailView = (StringrFooterView *)detailsCellSubview;
            [stringDetailView refreshLikesAndComments];
        }
    }
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (StringrFooterView *)addFooterViewToCellWithObject:(PFObject *)object inSection:(NSUInteger)section
{
    static float const contentViewWidth = 320.0;
    static float const contentViewHeight = 41.5;
    static float const contentFooterViewWidthPercentage = .93;
    
    float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
    CGRect footerRect = CGRectMake(footerXLocation, 0, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
    StringrFooterView *footerView = [[StringrFooterView alloc] initWithFrame:footerRect fullWidthCell:NO withObject:object];
    [footerView setSection:section];
    [footerView setDelegate:self];
    
    return footerView;
}

- (void)configureHeader:(StringrStringHeaderView *)headerView forSection:(NSUInteger)section withString:(PFObject *)string
{
    headerView.section = section;
    headerView.stringForHeader = string;
    headerView.delegate = self;
}



//*********************************************************************************/
#pragma mark - UITableView DataSource
//*********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
    if (self.objects.count == self.objectsPerPage) {
        return self.objects.count + 1;
    }
     */
    
    return self.objects.count;
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One of the rows is for the footer view
    return 3;
}



//*********************************************************************************/
#pragma mark - UITableView Delegate
//*********************************************************************************/

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < self.objects.count) {
        return 23.5f;
    }
    
    return 0.0f;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), [self tableView:tableView heightForHeaderInSection:section]);
    
    TestTableViewHeader *headerView = [[TestTableViewHeader alloc] initWithFrame:frame];
    
    return headerView;
}

/*

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.objects.count) {
        StringrStringHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        
        if (!headerView) {
            headerView = [[StringrStringHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        }
        
        PFObject *string = [self.objects objectAtIndex:section];
        
        if (string) {
            [self configureHeader:headerView forSection:section withString:string];
        }

        return headerView;
    }
    
    return nil;
}
 */

/*
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
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 270.0f;
    }
    else if (indexPath.row == 1) {
        return 47.0f;
    }
    else if (indexPath.row ==2) {
        return 55.0f;
    }
    
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(StringTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [cell setCollectionViewDataSourceDelegate:self index:indexPath.section];
        
        NSInteger index = cell.stringCollectionView.index;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell.stringCollectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }
}



//*********************************************************************************/
#pragma mark - PFQueryTableViewController
//*********************************************************************************/

- (PFQuery *)queryForTable
{
    PFQuery *query = [self getQueryForTable];
    query.limit = 100;
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.rootViewController isParseReachable]) {
        query = [PFQuery queryWithClassName:@"no_class"];
    }

    return query;
}

- (UITableViewCell *)testTableViewCells:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StringCell" forIndexPath:indexPath];
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StringFooterTitleCell" forIndexPath:indexPath];
    }
    else if (indexPath.row ==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StringFooterActionCell" forIndexPath:indexPath];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    return [self testTableViewCells:tableView indexPath:indexPath];
    
    /*
    PFObject *string = object;
    
    // It's possible for this object to be of type statistic or activity. This just gets the string
    // value from either of those classes
    if ([object.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [object objectForKey:kStringrStatisticsStringKey];
    }
    else if ([object.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [object objectForKey:kStringrActivityStringKey];
    }
    
//    if (string) {
        if (indexPath.section == self.objects.count) {
            // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
            UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
            return cell;
        }
        else if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"StringTableViewCell";
            StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (!stringCell) {
                stringCell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                NSLog(@"cell for string row");
            }
            
            [stringCell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return stringCell;
        }
        else if (indexPath.row == 1) {
            static NSString *cellIdentifier = @"StringTableViewFooter";
            
            UITableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if (!footerCell) {
                footerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            [footerCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
            [footerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                StringrFooterView *footerView = [self addFooterViewToCellWithObject:string inSection:indexPath.section];
                
                [footerCell.contentView addSubview:footerView];
            });

            return footerCell;
        }
        else {
            return nil;
        }
//    }
//    else {
//        return nil;
//    }
     */
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count > 0) {
        // instantiates string photos with blank objects of count self.objects
        self.stringPhotos = [[NSMutableArray alloc] initWithCapacity:self.objects.count];
        for (int i = 0; i < self.objects.count; i++) {
            [self.stringPhotos addObject:@""];
        }
        
        // Querries all of the photos for the strings and puts them in an array
        for (int i = 0; i < self.objects.count; i++) {
            PFObject *string = [self.objects objectAtIndex:i];
            
            if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
                string = [string objectForKey:kStringrStatisticsStringKey];
            } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
                string = [string objectForKey:kStringrActivityStringKey];
            }
            
            if (string) {
                PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
                [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:string];
                [stringPhotoQuery orderByAscending:@"photoOrder"]; // photoOrder: each photo has a number associated with where it falls into the string
                [stringPhotoQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
                [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
                    if (!error) {
                        for (PFObject *photo in photos) {
                            if (!photo) {
                                return;
                            }
                        }
                        
                        [self.stringPhotos replaceObjectAtIndex:i withObject:photos];
                        
                        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                        [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }];
            }
        }
    }
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



//*********************************************************************************/
#pragma mark - UICollectionView Data Source
//*********************************************************************************/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(StringCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *stringPhotos = self.stringPhotos[collectionView.index];
    
    if ([stringPhotos isKindOfClass:[NSArray class]]) {
        return stringPhotos.count;
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(StringCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StringCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        
        NSArray *stringPhotos = self.stringPhotos[collectionView.index];
        PFObject *photo = stringPhotos[indexPath.item];
        
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



//*********************************************************************************/
#pragma mark - UICollectionView Delegate
//*********************************************************************************/

- (void)collectionView:(StringCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *stringPhotos = self.stringPhotos[collectionView.index];
    
    if (stringPhotos) {
        StringrPhotoDetailViewController *photoDetailVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        [photoDetailVC setEditDetailsEnabled:NO];
        
        // Sets the photos to be displayed in the photo pager
        [photoDetailVC setPhotosToLoad:stringPhotos];
        [photoDetailVC setSelectedPhotoIndex:indexPath.item];
        [photoDetailVC setStringOwner:self.objects[collectionView.index]];
        
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
    
}



//*********************************************************************************/
#pragma mark - StringCollectionViewFlowLayout Delegate
//*********************************************************************************/

- (CGSize)collectionView:(StringCollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *stringPhotos = self.stringPhotos[collectionView.index];
    id photo = stringPhotos[indexPath.item];
    
    NSNumber *width = 0;
    NSNumber *height = 0;
    
    if (photo && [photo isKindOfClass:[PFObject class]]) {
        PFObject *photoObject = (PFObject *)photo;
        
        width = [photoObject objectForKey:kStringrPhotoPictureWidth];
        height = [photoObject objectForKey:kStringrPhotoPictureHeight];
    } else if (photo && [photo isKindOfClass:[UIImage class]]) {
        UIImage *photoImage = (UIImage *)photo;
        
        width = [NSNumber numberWithInt:photoImage.size.width];
        height = [NSNumber numberWithInt:photoImage.size.height];
    }
    
    
    return CGSizeMake([width floatValue], [height floatValue]);
}



//*********************************************************************************/
#pragma mark - UIScrollViewDelegate Methods
//*********************************************************************************/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[StringCollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    StringCollectionView *collectionView = (StringCollectionView *)scrollView;
    NSInteger index = collectionView.index;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}



//*********************************************************************************/
#pragma mark - StringrHeaderViewView Delegate
//*********************************************************************************/

- (void)headerView:(StringrStringHeaderView *)headerView tappedHeaderInSection:(NSUInteger)section withString:(PFObject *)string
{
    StringrStringDetailViewController *detailVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
    
    // passes the appropriate string object based around what type of parse object has been querried
    if ([string.parseClassName isEqualToString:kStringrStatisticsClassKey]) {
        string = [string objectForKey:kStringrStatisticsStringKey];
    } else if ([string.parseClassName isEqualToString:kStringrActivityClassKey]) {
        string = [string objectForKey:kStringrActivityStringKey];
    }
    
    [detailVC setStringToLoad:string];
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



//*********************************************************************************/
#pragma mark - StringrFooterView Delegate
//*********************************************************************************/

- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader
{
    if (uploader) {
        StringrProfileViewController *profileVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        
        [profileVC setUserForProfile:uploader];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        [profileVC setHidesBottomBarWhenPushed:YES];

        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object
{

}

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object inSection:(NSUInteger)section
{
    if (object) {
        StringrCommentsTableViewController *commentsVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:object];
        [commentsVC setSection:section];
        [commentsVC setDelegate:self];

        [commentsVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}



//*********************************************************************************/
#pragma mark - StringrCommentsTableView Delegate
//*********************************************************************************/

- (void)commentsTableView:(StringrCommentsTableViewController *)commentsTableView didChangeCommentCountInSection:(NSUInteger)section
{
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:1 inSection:section];
    UITableViewCell *footerCell = [self.tableView cellForRowAtIndexPath:footerIndexPath];
    
    // finds the footer view inside of the footer table view cell and updates the comments/like amount
    for (UIView *view in footerCell.contentView.subviews) {
        if ([view isKindOfClass:[StringrFooterView class]]) {
            StringrFooterView *footerView = (StringrFooterView *)view;
            [footerView refreshLikesAndComments];
        }
    }
}


@end
