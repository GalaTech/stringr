//
//  StringrStringCommentsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringCommentsViewController.h"
#import "StringrNavigationController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewCell.h"
#import "StringrWriteCommentViewController.h"
#import "StringrPathImageView.h"
#import "StringrLoadMoreTableViewCell.h"
#import "StringrWriteAndEditTextViewController.h"

@interface StringrStringCommentsViewController () <UINavigationControllerDelegate, StringrCommentsTableViewCellDelegate, StringrWriteCommentDelegate>

@property (strong, nonatomic) NSMutableArray *commentsThread;

@property (strong, nonatomic) StringrWriteCommentViewController *writeCommentVC;
@property (strong, nonatomic) StringrCommentsTableViewCell *commentsTableVC;
@property (strong, nonatomic) StringrProfileViewController *profileVC;
@property (strong, nonatomic) StringrNavigationController *navigationVC;
@property (strong, nonatomic) NSMutableArray *commentUsers;

@end

@implementation StringrStringCommentsViewController

#pragma mark - Lifecycle


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrActivityClassKey;
        self.pullToRefreshEnabled = YES;
        //self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Comments";
    
    [self.tableView setScrollsToTop:YES];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeComment)];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.1f)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:footerView];
    [self.tableView registerClass:[StringrLoadMoreTableViewCell class] forCellReuseIdentifier:@"loadMoreCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Custom Accessors

- (NSMutableArray *)commentUsers
{
    if (!_commentUsers) {
        _commentUsers = [[NSMutableArray alloc] init];
    }
    
    return _commentUsers;
}




#pragma mark - Actions

- (void)writeComment
{
    StringrWriteCommentViewController *writeCommentVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardWriteCommentID];
    [writeCommentVC setObjectToCommentOn:self.objectForCommentThread];
    [writeCommentVC setDelegate:self];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:writeCommentVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}



#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.objects.count == self.objectsPerPage) {
        return [self.objects count] + 1;
    }
    
    return [self.objects count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([cell isKindOfClass:[StringrCommentsTableViewCell class]]) {
        StringrCommentsTableViewCell *commentsCell = (StringrCommentsTableViewCell *)cell;
        [commentsCell setDelegate:self];
        
        NSDictionary *comment = [self.commentsThread objectAtIndex:indexPath.row];
        
        [commentsCell.commentsProfileImage setImage:[UIImage imageNamed:[comment objectForKey:@"profileImage"]]];
        [commentsCell.commentsProfileDisplayName setText:[comment objectForKey:@"profileDisplayName"]];
        [commentsCell.commentsUploadDateTime setText:[comment objectForKey:@"uploadDate"]];
        [commentsCell.commentsTextComment setText:[comment objectForKey:@"commentText"]];
    }
    
    return cell;
}
 */




#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.commentsEditable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *commentToRemove = [self.objects objectAtIndex:indexPath.row];
        [commentToRemove deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.objectForCommentThread saveInBackground];
                [self loadObjects];
            }
        }];
        
        [[StringrCache sharedCache] decrementCommentCountForObject:commentToRemove];
        
        if ([StringrUtility objectIsString:self.objectForCommentThread]) {
            PFObject *stringStatistics = [self.objectForCommentThread objectForKey:kStringrStringStatisticsKey];
            [stringStatistics incrementKey:kStringrStatisticsCommentCountKey byAmount:@(-1)];
            [stringStatistics saveEventually];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.objects.count) {
        return 45.0f;
    }
    
    // dynamic comment cell height
    PFObject *comment = [self.objects objectAtIndex:indexPath.row];
    NSString *commentText = [comment objectForKey:kStringrActivityContentKey];
    CGFloat cellHeight = [StringrUtility heightForLabelWithNSString:commentText] + 50;
    
    return cellHeight;
}


/*

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewHeight = CGRectGetHeight(self.tableView.bounds);
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;

    if (scrollView.contentOffset.y >= scrollViewBottomOffset) {
        [self loadNextPage];
    }
}
 */




#pragma mark - PFQueryTableView DataSource

- (PFQuery *)queryForTable
{
    PFQuery *query = [self getQueryForTable];
    
    if (self.objects.count == 0) {
        // I changed the cache policy from kPFCachePolicyCacheThenNetwork because this was resulting
        // in duplicate objects being loaded
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString * cellIdentifier = @"commentCell";
    //UITableViewCell *cell;
    
    
    
    if (indexPath.row == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *loadMoreCell = (StringrLoadMoreTableViewCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return loadMoreCell;
    } else {
        StringrCommentsTableViewCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //StringrCommentsTableViewCell *commentsCell = (StringrCommentsTableViewCell *)cell;
        
        if (!commentsCell) {
            commentsCell = [[StringrCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [commentsCell setDelegate:self];
        [commentsCell.commentsTextComment setText:[object objectForKey:kStringrActivityContentKey]];
        [commentsCell.commentsUploadDateTime setText:[StringrUtility timeAgoFromDate:object.createdAt]];
        
        PFUser *commentUser = [object objectForKey:kStringrActivityFromUserKey];
        
        [commentUser fetchInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            NSString *commentorUsername = [StringrUtility usernameFormattedWithMentionSymbol:[user objectForKey:kStringrUserUsernameCaseSensitive]];
            [commentsCell.commentsProfileDisplayName setText:commentorUsername];
            
            // allows easy access to this users profile when profile image is tapped
            [self.commentUsers addObject:user];
            
            UIActivityIndicatorView *loadingProfileImageActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            float width = CGRectGetWidth(commentsCell.commentsProfileImage.frame) / 2;
            float height = CGRectGetHeight(commentsCell.commentsProfileImage.frame) / 2;
            [loadingProfileImageActivityIndicator setCenter:CGPointMake(width, height)];
            [commentsCell.commentsProfileImage addSubview:loadingProfileImageActivityIndicator];
            //[loadingProfileImageActivityIndicator startAnimating];
            
            PFFile *profileImageFile = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
            [commentsCell.commentsProfileImage setFile:profileImageFile];
            // set the tag to the row so that we can access the correct user when tapping on a profile image
            [commentsCell.commentsProfileImage setTag:indexPath.row];
            [commentsCell.commentsProfileImage loadInBackgroundWithIndicator];
            
            /*
            [commentsCell.commentsProfileImage loadInBackground:^(UIImage *image, NSError *error) {
                if (!error) {
                    [loadingProfileImageActivityIndicator stopAnimating];
                }
            }];
             */
        }];
        
        return commentsCell;
    }
}

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



#pragma mark - StringrCommentsTableViewCell Delegate

- (void)tappedCommentorProfileImage:(NSInteger)index
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
    
    PFUser *userForProfile = [self.commentUsers objectAtIndex:index];

    [profileVC setUserForProfile:userForProfile];
    [profileVC setProfileReturnState:ProfileModalReturnState];
    
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}




#pragma mark - StringrWriteComment Delegate

- (void)reloadCommentTableView
{
    [self loadObjects];
}


@end
