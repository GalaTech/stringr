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
#import "StringrStringCommentsViewController.h"

@interface StringrActivityTableViewController () <StringrActivityTableViewCellDelegate>

@end

@implementation StringrActivityTableViewController

#pragma mark - Lifecycle

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
        self.paginationEnabled = YES;
        self.objectsPerPage = 15;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [StringrConstants kStringTableViewBackgroundColor];
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
    } else {
        return nil;
    }
}



#pragma mark - UITableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}




#pragma mark - UITableViewController Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *objectForIndexPath = [self.objects objectAtIndex:indexPath.row];
    NSString *activityType = [objectForIndexPath objectForKey:kStringrActivityTypeKey];
    
    if ([objectForIndexPath objectForKey:kStringrActivityStringKey]) {
        StringrStringDetailViewController *stringDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [stringDetailVC setStringToLoad:[objectForIndexPath objectForKey:kStringrActivityStringKey]];
        [stringDetailVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:stringDetailVC animated:YES];
    } else if ([objectForIndexPath objectForKey:kStringrActivityPhotoKey]) {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        
        PFObject *photo = [objectForIndexPath objectForKey:kStringrActivityPhotoKey];
        [photoDetailVC setPhotosToLoad:@[photo]];
        [photoDetailVC setStringOwner:[photo objectForKey:kStringrPhotoStringKey]];
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    } else if ([activityType isEqualToString:kStringrActivityTypeFollow]) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        [profileVC setUserForProfile:[objectForIndexPath objectForKey:kStringrActivityFromUserKey]];
        [profileVC setProfileReturnState:ProfileBackReturnState];
        [profileVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:profileVC animated:YES];
    }
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
    
    return activityQuery;
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellIdentifier = @"activityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringrActivityTableViewCell class]]) {
        StringrActivityTableViewCell *activityCell = (StringrActivityTableViewCell *)cell;
        [activityCell setDelegate:self];
        [activityCell setObjectForActivityCell:object];
        [activityCell setRowForActivityCell:indexPath.row];
    }
    
    
    return cell;
}




#pragma mark - StringrActivityTableViewCell Delegate

- (void)tappedActivityUserProfileImage:(PFUser *)user
{
    if (user) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
        
        [profileVC setUserForProfile:user];
        [profileVC setProfileReturnState:ProfileModalReturnState];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        
        [self presentViewController:navVC animated:YES completion:nil];
    }
}


@end
