//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringFeedViewController.h"

#import "StringrNavigationController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewController.h"
#import "StringrPhotoFeedViewController.h"
#import "StringrLoadingContentView.h"

#import "StringTableViewHeader.h"
#import "StringTableViewCell.h"
#import "StringTableViewTitleCell.h"
#import "StringTableViewActionCell.h"
#import "StringrLoadMoreTableViewCell.h"
#import "StringCollectionViewCell.h"

#import "StringrNetworkTask+LikeActivity.h"

#import "StringrString.h"

#import "UIColor+StringrColors.h"
#import "NSLayoutConstraint+StringrAdditions.h"

#import "StringrFlagContentHelper.h"
#import "StringrActionSheet.h"
#import "NHBalancedFlowLayout.h"

static NSString * const StringrStringFeedStoryboard = @"StringrStringFeedViewController";

@interface StringrStringFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, STGRStringFeedModelControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NHBalancedFlowLayoutDelegate, StringTableViewHeaderDelegate, StringTableViewActionCellDelegate, UIGestureRecognizerDelegate, StringrLoadingContentViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *contentOffsetDictionary;

@property (strong, nonatomic) UIStoryboard *mainStoryboard;
@property (strong, nonatomic) StringrLoadingContentView *loadingContentView;

@end

@implementation StringrStringFeedViewController

#pragma mark - Lifecycle

+ (StringrStringFeedViewController *)viewController
{
    StringrStringFeedViewController *stringFeedVC = [StringrStringFeedViewController new];
    return stringFeedVC;
}


+ (StringrStringFeedViewController *)stringFeedWithDataType:(StringrNetworkStringTaskType)taskType
{
    StringrStringFeedViewController *stringFeedVC = [StringrStringFeedViewController viewController];
    stringFeedVC.modelController.dataType = taskType;
    return stringFeedVC;
}


+ (instancetype)stringFeedWithCategory:(StringrExploreCategory *)category
{
    StringrStringFeedViewController *stringFeedVC = [StringrStringFeedViewController viewController];
    stringFeedVC.modelController.category = category;
    return stringFeedVC;
}


+ (StringrStringFeedViewController *)stringFeedWithStrings:(NSArray *)strings
{
    StringrStringFeedViewController *stringFeedVC = [StringrStringFeedViewController viewController];
    stringFeedVC.modelController.strings = strings;
    return stringFeedVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self setupLoadingContentView];
    [self setupTableView];
}


- (void)setupLoadingContentView
{
    self.loadingContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.loadingContentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsToFillSuperviewWithView:self.loadingContentView]];
}


- (void)setupTableView
{
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -13, 0); // accounts for last row's bottom margin
    [self.tableView setBackgroundColor:[UIColor stringTableViewBackgroundColor]];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self registerCellsForTableView];
    
//    [self.view addSubview:self.tableView];
//    [self.view addConstraints:[NSLayoutConstraint constraintsToFillSuperviewWithView:self.tableView]];
}


#pragma mark - Accessors

- (STGRStringFeedModelController *)modelController
{
    if (!_modelController) {
        _modelController = [STGRStringFeedModelController new];
        _modelController.delegate = self;
    }
    
    return _modelController;
}


- (StringrLoadingContentView *)loadingContentView
{
    if (!_loadingContentView) {
        _loadingContentView = [[[NSBundle mainBundle] loadNibNamed:@"StringrLoadingContentView" owner:self options:nil] firstObject];
        _loadingContentView.delegate = self;
    }
    
    return _loadingContentView;
}


- (NSMutableDictionary *)contentOffsetDictionary
{
    if (!_contentOffsetDictionary) {
        _contentOffsetDictionary = [NSMutableDictionary new];
    }
    
    return _contentOffsetDictionary;
}


#pragma mark - Private

- (void)registerCellsForTableView
{
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:StringTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"StringTableViewTitleCell" bundle:nil] forCellReuseIdentifier:StringTableViewTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"StringTableViewActionCell" bundle:nil] forCellReuseIdentifier:StringTableViewActionCellIdentifier];
}


#pragma mark - <StringrStringFeedModelControllerDelegate>

- (void)stringFeedDataWillUpdate
{
    [self.loadingContentView startLoading];
}


- (void)stringFeedLoadedContent
{
    [self.loadingContentView stopLoading];
    
    if (self.tableView.superview != self.view) {
        [UIView transitionWithView:self.view
                          duration:0.33f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.loadingContentView removeConstraints:[NSLayoutConstraint constraintsToFillSuperviewWithView:self.loadingContentView]];
                            [self.loadingContentView removeFromSuperview];
                            self.loadingContentView = nil;
                            
                            [self.view addSubview:self.tableView];
                            [self.view addConstraints:[NSLayoutConstraint constraintsToFillSuperviewWithView:self.tableView]];
                        } completion:nil];
    }
}

- (void)stringFeedLoadedNoContent
{
    [self.loadingContentView stopLoading];
    [self.loadingContentView enableNoContentViewWithMessage:@"No Strings"];
}


- (void)stringFeedDataDidLoadForIndexSets:(NSArray *)indexSets
{
    [self.tableView beginUpdates];
    
    for (NSIndexSet *indexSet in indexSets) {
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView endUpdates];
}


- (void)stringFeedPhotosDidUpdateAtIndexPath:(NSIndexPath *)indexPath
{
    StringTableViewCell *stringCell = (StringTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    [stringCell.stringCollectionView reloadData];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelController.strings.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StringrString *string = self.modelController.strings[indexPath.section];
    
    switch (indexPath.row) {
        case 0:
            return [self stringCellAtIndexPath:indexPath string:string];
            break;
        case 1:
            return [self titleCellAtIndexPath:indexPath string:string];
            break;
        case 2:
            return [self actionCellAtIndexPath:indexPath string:string];
        default:
            return [UITableViewCell new];
            break;
    }
}


- (StringTableViewCell *)stringCellAtIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    StringTableViewCell *stringCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewCellIdentifier forIndexPath:indexPath];
    
    [self configureStringCell:stringCell atIndexPath:indexPath string:string];
    
    return stringCell;
}


- (void)configureStringCell:(StringTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    if (!cell) {
        cell = [[StringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringTableViewCellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


- (StringTableViewTitleCell *)titleCellAtIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    StringTableViewTitleCell *footerCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewTitleCellIdentifier forIndexPath:indexPath];
    
    [self configureTitleCell:footerCell atIndexPath:indexPath string:string];
    
    return footerCell;
}


- (void)configureTitleCell:(StringTableViewTitleCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    if (!cell) {
        cell = [StringTableViewTitleCell new];
    }
    
    [cell configureFooterCellWithString:string];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (StringTableViewActionCell *)actionCellAtIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    StringTableViewActionCell *actionCell = [self.tableView dequeueReusableCellWithIdentifier:StringTableViewActionCellIdentifier forIndexPath:indexPath];
    
    [self configureActionCell:actionCell atIndexPath:indexPath string:string];
    
    return actionCell;
}


- (void)configureActionCell:(StringTableViewActionCell *)cell atIndexPath:(NSIndexPath *)indexPath string:(StringrString *)string
{
    [cell configureActionCellWithString:string];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - <UITableViewDelegate>

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
    StringrString *string = self.modelController.strings[section];
    
    StringTableViewHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"StringTableViewHeader" owner:self options:nil][0];
    [headerView configureHeaderWithString:string];
    headerView.delegate = self;
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.modelController.strings.count) {
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
    
    StringrString *string = self.modelController.strings[indexPath.section];
    
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
    
    CGFloat yOffset = tableView.contentOffset.y;
    CGFloat height = self.tableView.contentSize.height - self.tableView.frame.size.height;
    CGFloat scrolledPercentage = yOffset / height;
    
    if (scrolledPercentage > .6f && !self.modelController.isLoading && self.modelController.hasNextPage) {
        [self.modelController loadNextPage];
    }
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(StringCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    StringrString *string = self.modelController.strings[collectionView.index];
    return string.photos.count;
}


- (UICollectionViewCell *)collectionView:(StringCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StringCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        StringrString *string = self.modelController.strings[collectionView.index];
        StringrPhoto *photo = string.photos[indexPath.item];
        
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        
        if (photo) {
            [stringCell.loadingImageIndicator setHidden:NO];
            [stringCell.loadingImageIndicator startAnimating];
            
            [photo loadImageInBackground:^(UIImage *image, NSError *error) {
                stringCell.cellImage.image = image;
                [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
                [stringCell.loadingImageIndicator stopAnimating];
                [stringCell.loadingImageIndicator setHidden:YES];
                
                [UIView animateWithDuration:0.2 animations:^{
                    stringCell.cellImage.alpha = 1.0f;
                }];
            }];
        }
        
        return stringCell;
    } else {
        return cell;
    }
}


#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(StringCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    StringrString *string = self.modelController.strings[collectionView.index];
//    
//    if (string.photos) {
//        StringrPhotoDetailViewController *photoDetailVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
//        
//        [photoDetailVC setEditDetailsEnabled:NO];
//        
//        // Sets the photos to be displayed in the photo pager
//        [photoDetailVC setPhotosToLoad:string.photos];
//        [photoDetailVC setSelectedPhotoIndex:indexPath.item];
//        [photoDetailVC setStringOwner:((StringrString*)self.modelController.strings[collectionView.index]).parseString];
//        
//        [self.navigationController pushViewController:photoDetailVC animated:YES];
//    }
}


#pragma mark - <StringCollectionViewFlowLayoutDelegate>

- (CGSize)collectionView:(StringCollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringrString *string = self.modelController.strings[collectionView.index];
    StringrPhoto *photo = string.photos[indexPath.item];
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (photo) {
        width = photo.width;
        height = photo.height;
    }
    
    return CGSizeMake(width, height);
}


#pragma mark - <UIScrollViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[StringCollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    StringCollectionView *collectionView = (StringCollectionView *)scrollView;
    NSInteger index = collectionView.index;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}


#pragma mark - <StringTableViewHeaderDelegate>

- (void)profileImageTappedForUser:(PFUser *)user
{
    if (user) {
        StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
        
        [profileVC setUserForProfile:user];
        [profileVC setProfileReturnState:ProfileBackReturnState];

        [self.navigationController pushViewController:profileVC animated:YES];
    }
}


- (void)stringHeader:(StringTableViewHeader *)header didTapPhotoViewForString:(StringrString *)string
{
    StringrPhotoFeedViewController *photoFeedVC = [StringrPhotoFeedViewController photoFeedFromPhotos:string.photos];

    [self.navigationController pushViewController:photoFeedVC animated:YES];
}


#pragma mark - <StringTableViewActionCellDelegate>

- (void)actionCell:(StringTableViewActionCell *)cell tappedLikeButton:(UIButton *)button liked:(BOOL)liked withBlock:(void (^)(BOOL))block
{
    if (liked) {
        [StringrNetworkTask likeObjectInBackground:cell.string.parseString block:^(BOOL succeeded, NSError *error) {
            if (block) {
                block(succeeded);
            }
        }];
    }
    else {
        [StringrNetworkTask unlikeObjectInBackground:cell.string.parseString block:^(BOOL succeeded, NSError *error) {
            if (block) {
                block(succeeded);
            }
        }];
    }
}


- (void)actionCell:(StringTableViewActionCell *)cell tappedCommentButton:(UIButton *)button
{
    if (cell.string) {
        StringrCommentsTableViewController *commentsVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:cell.string.parseString];
//        [commentsVC setDelegate:self];
        
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}


- (void)actionCell:(StringTableViewActionCell *)cell tappedActionButton:(UIButton *)button
{
    StringrActionSheet *stringActionSheet = [[StringrActionSheet alloc] initWithTitle:@"String Actions" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share", @"Flag", nil];
    stringActionSheet.object = cell.string.parseString;
    
    [stringActionSheet showInView:self.view];
}


#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(StringrActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
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


#pragma mark - <StringrLoadingContentViewDelegate>

- (void)loadingContentViewDidTapRefresh:(StringrLoadingContentView *)loadingContentView
{
    [self.modelController refresh];
}

@end
