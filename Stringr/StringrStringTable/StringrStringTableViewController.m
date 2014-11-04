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
#import "UIColor+StringrColors.h"
#import "StringrNetworkTask+LikeActivity.h"
#import "StringrFlagContentHelper.h"
#import "StringrActionSheet.h"

#import "StringTableViewHeader.h"
#import "TestTableViewStringCell.h"
#import "StringTableViewTitleCell.h"
#import "TestTableViewFooterActionCell.h"

@interface StringrStringTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NHBalancedFlowLayoutDelegate, StringrCommentsTableViewDelegate, StringTableViewHeaderDelegate, TestTableViewFooterActionDelegate>

@property (strong, nonatomic) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation StringrStringTableViewController

#pragma mark - Lifecycle

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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StringTableViewFooter"];
    [self.tableView setBackgroundColor:[UIColor stringTableViewBackgroundColor]];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self registerCellsForTableView];
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


#pragma mark - Accessors

- (NSMutableDictionary *)contentOffsetDictionary
{
    if (!_contentOffsetDictionary) {
        _contentOffsetDictionary = [NSMutableDictionary new];
    }
    
    return _contentOffsetDictionary;
}


#pragma mark - Action Handlers

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


#pragma mark - Private

- (void)registerCellsForTableView
{
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StringTableViewTitleCell" bundle:nil] forCellReuseIdentifier:StringTableViewTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TestTableViewFooterActionCell" bundle:nil] forCellReuseIdentifier:@"StringFooterActionCell"];
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
//    if (self.objects.count == self.objectsPerPage) {
//        return self.objects.count + 1;
//    }
    
    return self.objects.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /// If I returned 1 for the load more section would this work correctly?
    
//    if (self.objects.count - 1 == self.objectsPerPage) {
//        return 1;
//    }
    // One of the rows is for the footer view
    return 3;
}


#pragma mark - UITableView Delegate

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
    PFObject *string = [StringrUtility stringFromObject:self.objects[section]];
    
    StringTableViewHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"StringTableViewHeader" owner:self options:nil][0];
    [headerView configureHeaderWithString:string];
    headerView.delegate = self;
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.objects.count) {
        if (indexPath.row == 0) {
            return StringTableCellHeight;
        }
        else if (indexPath.row == 1) {
            return FooterTitleCellHeight;
        }
        else if (indexPath.row == 2) {
            return FooterActionCellHeight;
        }
    }
    
    return 44.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return StringTableCellHeight;
    }
    else if (indexPath.row == 1) {
        return [self heightForTitleCellAtIndexPath:indexPath];
    }
    else if (indexPath.row == 2) {
        return FooterActionCellHeight;
    }
    
    return 0.0f;
}


- (CGFloat)heightForTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static StringTableViewTitleCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewTitleCellIdentifier];
    });
    
    PFObject *string = [StringrUtility stringFromObject:self.objects[indexPath.section]];
    
    [self configureTitleCell:sizingCell atIndexPath:indexPath string:string];
    
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 0.0f);
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
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


#pragma mark - PFQueryTableViewController

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
            PFObject *string = [StringrUtility stringFromObject:self.objects[i]];
            
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
                        [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }];
            }
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFObject *string = [StringrUtility stringFromObject:object];
    
//    if (indexPath.section == self.objects.count) {
//        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
//        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
//        return cell;
//    }
    if (indexPath.row == 0) {
        return [self stringCellAtIndexPath:indexPath string:string];
    }
    else if (indexPath.row == 1) {
        return [self titleCellAtIndexPath:indexPath string:string];
    }
    else if (indexPath.row == 2) {
        return [self actionCellAtIndexPath:indexPath string:string];
    }
    
    return nil;
}


- (StringTableViewCell *)stringCellAtIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    StringTableViewCell *stringCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewCellIdentifier forIndexPath:indexPath];
    
    [self configureStringCell:stringCell atIndexPath:indexPath string:string];
    
    return stringCell;
}


- (void)configureStringCell:(StringTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    if (!cell) {
        cell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringTableViewCellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


- (StringTableViewTitleCell *)titleCellAtIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    StringTableViewTitleCell *footerCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewTitleCellIdentifier forIndexPath:indexPath];
    
    [self configureTitleCell:footerCell atIndexPath:indexPath string:string];
    
    return footerCell;
}


- (void)configureTitleCell:(StringTableViewTitleCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    if (!cell) {
        cell = [StringTableViewTitleCell new];
    }
    
    [cell configureFooterCellWithString:string];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (TestTableViewFooterActionCell *)actionCellAtIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    TestTableViewFooterActionCell *actionCell = [self.tableView dequeueReusableCellWithIdentifier:@"StringFooterActionCell" forIndexPath:indexPath];
    
    [self configureActionCell:actionCell atIndexPath:indexPath string:string];
    
    return actionCell;
}


- (void)configureActionCell:(TestTableViewFooterActionCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(PFObject *)string
{
    [cell configureActionCellWithString:string];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    //PFTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
    //[loadCell setBackgroundColor:[UIColor stringrLightGrayColor]];
    
    StringrLoadMoreTableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
    
    if (!loadMoreCell) {
        loadMoreCell = [[StringrLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
    }
    
    return loadMoreCell;
}
 

#pragma mark - UICollectionView Data Source

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


#pragma mark - UICollectionView Delegate

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


#pragma mark - StringCollectionViewFlowLayout Delegate

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


#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[StringCollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    StringCollectionView *collectionView = (StringCollectionView *)scrollView;
    NSInteger index = collectionView.index;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}


#pragma mark - StringrCommentsTableView Delegate

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


#pragma mark - StringrTableViewHeaderDelegate

- (void)profileImageTappedForUser:(PFUser *)user
{
    if (user) {
        StringrProfileViewController *profileVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        
        [profileVC setUserForProfile:user];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        [profileVC setHidesBottomBarWhenPushed:YES];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}


#pragma mark - StringrTableViewActionFooter Delegate

- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedLikeButton:(UIButton *)button liked:(BOOL)liked withBlock:(void (^)(BOOL))block
{
    if (liked) {
        [StringrNetworkTask likeObjectInBackground:cell.string block:^(BOOL succeeded, NSError *error) {
            if (block) {
                block(succeeded);
            }
        }];
    }
    else {
        [StringrNetworkTask unlikeObjectInBackground:cell.string block:^(BOOL succeeded, NSError *error) {
            if (block) {
                block(succeeded);
            }
        }];
    }
}


- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedCommentButton:(UIButton *)button
{
    if (cell.string) {
        StringrCommentsTableViewController *commentsVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:cell.string];
        [commentsVC setDelegate:self];
        
        [commentsVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}


- (void)actionCell:(TestTableViewFooterActionCell *)cell tappedActionButton:(UIButton *)button
{
    StringrActionSheet *stringActionSheet = [[StringrActionSheet alloc] initWithTitle:@"String Actions" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share", @"Flag", nil];
    stringActionSheet.object = cell.string;
    
    [stringActionSheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(StringrActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Share"]) {
        NSLog(@"Share String!");
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Flag"]) {
        [StringrFlagContentHelper flagContent:actionSheet.object withFlaggingUser:[PFUser currentUser]];
    }
}

@end
