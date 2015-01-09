//
//  StringrActivityTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrActivityTableViewController.h"
#import "StringrActivityTableViewCell.h"
#import "StringrProfileViewController.h"
#import "StringrNavigationController.h"
#import "StringrStringDetailViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrCommentsTableViewController.h"
#import "StringrLoadMoreTableViewCell.h"
#import "UIColor+StringrColors.h"

static NSString * const StringrActivityTableViewStoryboardName = @"StringrActivityTableViewStoryboard";

@interface StringrActivityTableViewController () <StringrActivityTableViewCellDelegate>

@end

@implementation StringrActivityTableViewController

#pragma mark - Lifecycle

+ (StringrActivityTableViewController *)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrActivityTableViewStoryboardName bundle:nil];
    return (StringrActivityTableViewController *)[storyboard instantiateInitialViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrActivityClassKey;
        self.pullToRefreshEnabled = YES;
//        self.paginationEnabled = YES;
        self.objectsPerPage = 30;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivity) name:@"currentUserHasNewActivities" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Activity";
    
    self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc activity");
}



#pragma mark - Private

+ (NSString *)stringForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:kStringrActivityTypeLike]) {
        return kStringrActivityTypeLike;
    } else if ([activityType isEqualToString:kStringrActivityTypeComment]) {
        return kStringrActivityTypeComment;
    } else if ([activityType isEqualToString:kStringrActivityTypeFollow]) {
        return kStringrActivityTypeFollow;
    } else if ([activityType isEqualToString:kStringrActivityTypeMention]) {
        return kStringrActivityTypeMention;
    } else if ([activityType isEqualToString:kStringrActivityTypeAddedPhotoToPublicString]) {
        return kStringrActivityTypeAddedPhotoToPublicString;
    } else {
        return nil;
    }
}


- (void)refreshActivity
{
    [self loadObjects];
}



#pragma mark - UITableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.objects.count == self.objectsPerPage) {
//        return self.objects.count + 1;
//    }
    
    return self.objects.count;
}



#pragma mark - UITableViewController Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == self.objects.count) [self loadNextPage];
    
    PFObject *objectForIndexPath = [self.objects objectAtIndex:indexPath.row]; // activity object
    PFObject *stringToLoad = [objectForIndexPath objectForKey:kStringrActivityStringKey]; // string object
    PFObject *photoToLoad = [objectForIndexPath objectForKey:kStringrActivityPhotoKey]; // photo object

    NSString *activityType = [objectForIndexPath objectForKey:kStringrActivityTypeKey];
    
    if ([objectForIndexPath objectForKey:kStringrActivityPhotoKey] && [objectForIndexPath objectForKey:kStringrActivityStringKey]) { // added photo to public string
        if (!stringToLoad) return;
        StringrStringDetailViewController *stringDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        stringDetailVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        [stringDetailVC setStringToLoad:stringToLoad];
        [stringDetailVC setHidesBottomBarWhenPushed:YES];
        
        StringrPhotoDetailViewController *photoDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        photoDetailVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        
        [photoDetailVC setPhotosToLoad:@[photoToLoad]];
        [photoDetailVC setStringOwner:[photoToLoad objectForKey:kStringrPhotoStringKey]];
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        NSArray *currentViewControllers = self.navigationController.viewControllers;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:currentViewControllers];
        [viewControllers addObject:stringDetailVC];
        [viewControllers addObject:photoDetailVC];
        
        [self.navigationController setViewControllers:viewControllers animated:YES];
    } else if ([[objectForIndexPath objectForKey:kStringrActivityContentKey] isEqualToString:kStringrActivityContentCommentKey]) { // mentioned in comment
        if (!stringToLoad) return;
        StringrStringDetailViewController *stringDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        stringDetailVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        [stringDetailVC setStringToLoad:stringToLoad];
        [stringDetailVC setHidesBottomBarWhenPushed:YES];
        
        StringrCommentsTableViewController *commentsVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
        [commentsVC setObjectForCommentThread:stringToLoad];
        commentsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        
        // Pushes both the String detail and comments onto the navVC
        NSArray *currentViewControllers = self.navigationController.viewControllers;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:currentViewControllers];
        [viewControllers addObject:stringDetailVC];
        [viewControllers addObject:commentsVC];
        
        [self.navigationController setViewControllers:viewControllers animated:YES];
    } else if ([objectForIndexPath objectForKey:kStringrActivityStringKey]) { // Activity on a string
        if (!stringToLoad) return;
        if ([[objectForIndexPath objectForKey:kStringrActivityTypeKey] isEqualToString:kStringrActivityTypeComment]) { // Commented on your string
            StringrStringDetailViewController *stringDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
            stringDetailVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
            [stringDetailVC setStringToLoad:stringToLoad];
            [stringDetailVC setHidesBottomBarWhenPushed:YES];
            
            StringrCommentsTableViewController *commentsVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
            [commentsVC setObjectForCommentThread:stringToLoad];
            commentsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
            
            // Pushes both the String detail and comments onto the navVC
            NSArray *currentViewControllers = self.navigationController.viewControllers;
            NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:currentViewControllers];
            [viewControllers addObject:stringDetailVC];
            [viewControllers addObject:commentsVC];
            
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } else { // Liked Your String
            StringrStringDetailViewController *stringDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
            [stringDetailVC setStringToLoad:stringToLoad];
            [stringDetailVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:stringDetailVC animated:YES];
        }
    } else if ([objectForIndexPath objectForKey:kStringrActivityPhotoKey]) { // Activity on a Photo
        if (!photoToLoad) return;
        if ([[objectForIndexPath objectForKey:kStringrActivityTypeKey] isEqualToString:kStringrActivityTypeComment]) { // Commented on your photo
            StringrPhotoDetailViewController *photoDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            photoDetailVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
            
            [photoDetailVC setPhotosToLoad:@[photoToLoad]];
            [photoDetailVC setStringOwner:[photoToLoad objectForKey:kStringrPhotoStringKey]];
            [photoDetailVC setHidesBottomBarWhenPushed:YES];
            
            StringrCommentsTableViewController *commentsVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardCommentsID];
            [commentsVC setObjectForCommentThread:photoToLoad];
            commentsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
            
            // Pushes both the Photo detail and comments onto the navVC
            NSArray *currentViewControllers = self.navigationController.viewControllers;
            NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:currentViewControllers];
            [viewControllers addObject:photoDetailVC];
            [viewControllers addObject:commentsVC];
            
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } else { // Liked your photo
             StringrPhotoDetailViewController *photoDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            
             [photoDetailVC setPhotosToLoad:@[photoToLoad]];
             [photoDetailVC setStringOwner:[photoToLoad objectForKey:kStringrPhotoStringKey]];
             [photoDetailVC setHidesBottomBarWhenPushed:YES];
             
             [self.navigationController pushViewController:photoDetailVC animated:YES];
        }
    } else if ([activityType isEqualToString:kStringrActivityTypeFollow]) { // Follow activity action
        StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
        [profileVC setUserForProfile:[objectForIndexPath objectForKey:kStringrActivityFromUserKey]];
        [profileVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
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

- (PFQuery *)queryForTable
{
    // if there is no current user the query will return 0 objects
    if (![PFUser currentUser]) {
        PFQuery *activityQuery = [PFQuery queryWithClassName:self.parseClassName];
        [activityQuery setLimit:0];
        return activityQuery;
    }
    
    PFQuery *activityQuery = [PFQuery queryWithClassName:self.parseClassName];
    [activityQuery whereKey:kStringrActivityToUserKey equalTo:[PFUser currentUser]];
    [activityQuery whereKey:kStringrActivityFromUserKey notEqualTo:[PFUser currentUser]];
    [activityQuery whereKeyExists:kStringrActivityFromUserKey];
    [activityQuery includeKey:kStringrActivityFromUserKey];
    [activityQuery includeKey:kStringrActivityStringKey];
    [activityQuery includeKey:kStringrActivityPhotoKey];
    [activityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [activityQuery orderByDescending:@"createdAt"];
    
    // perform conditional to check if there is a network connection
    if (self.objects.count == 0) {
        [activityQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    }
    
    StringrAppDelegate *appDelegate = (StringrAppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.appViewController isParseReachable]) {
        activityQuery = [PFQuery queryWithClassName:@"no_class"];
    }
    
    return activityQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"You don't have any Activity"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Explore New Content"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellIdentifier = @"activityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *loadMoreCell = (StringrLoadMoreTableViewCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return loadMoreCell;
    } else if ([cell isKindOfClass:[StringrActivityTableViewCell class]]) {
        StringrActivityTableViewCell *activityCell = (StringrActivityTableViewCell *)cell;
        [activityCell setDelegate:self];
        [activityCell setObjectForActivityCell:object];
        [activityCell setRowForActivityCell:indexPath.row];
    }
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    StringrLoadMoreTableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
    
    if (!loadMoreCell) {
        loadMoreCell = [[StringrLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
    }
    
    return loadMoreCell;
}



#pragma mark - StringrActivityTableViewCell Delegate

- (void)tappedActivityUserProfileImage:(PFUser *)user
{
    if (user) {
        StringrProfileViewController *profileVC = [StringrProfileViewController viewController];
        
        [profileVC setUserForProfile:user];
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}



#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    StringrDiscoveryTabBarViewController *discoveryTabBarVC = [StringrDiscoveryTabBarViewController new];
    [discoveryTabBarVC setSelectedIndex:1]; // sets the selected tab to Discover
    
    //Need to implement a deep linking for explore buttons
}


@end
