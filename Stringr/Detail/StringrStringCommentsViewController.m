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

@property (weak, nonatomic) StringrWriteCommentViewController *writeCommentVC;
@property (weak, nonatomic) StringrCommentsTableViewCell *commentsTableVC;
@property (weak, nonatomic) StringrProfileViewController *profileVC;
@property (weak, nonatomic) StringrNavigationController *navigationVC;
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




#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowObjectId;
    if (indexPath.row < self.objects.count) {
         rowObjectId = [[[self.objects objectAtIndex:indexPath.row] objectForKey:kStringrActivityFromUserKey] objectId];
    }
    
    return self.commentsEditable || [rowObjectId isEqualToString:[[PFUser currentUser] objectId]];
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
        return 45.0f; // load more cell
    }
    
    // dynamic comment cell height
    PFObject *comment = [self.objects objectAtIndex:indexPath.row];
    NSString *commentText = [comment objectForKey:kStringrActivityContentKey];
    CGFloat cellHeight = [StringrUtility heightForLabelWithNSString:commentText] + 50;
    
    return cellHeight;
}




#pragma mark - PFQueryTableView DataSource

- (PFQuery *)queryForTable
{   
    NSString *forObjectKey = kStringrActivityStringKey;
    
    if ([self.objectForCommentThread.parseClassName isEqualToString:kStringrPhotoClassKey]) {
        forObjectKey = kStringrActivityPhotoKey;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
    [query whereKey:forObjectKey equalTo:self.objectForCommentThread];
    [query whereKeyExists:kStringrActivityFromUserKey];
    [query whereKeyExists:kStringrActivityContentKey];
    [query includeKey:kStringrActivityFromUserKey];
    [query orderByDescending:@"createdAt"];

    
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
    
    if (indexPath.row == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *loadMoreCell = (StringrLoadMoreTableViewCell *)[self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return loadMoreCell;
    } else {
        StringrCommentsTableViewCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!commentsCell) {
            commentsCell = [[StringrCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [commentsCell setDelegate:self];
        [commentsCell setObjectForCommentCell:object];
        [commentsCell setRowForCommentCell:indexPath.row];
        
        return commentsCell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    StringrLoadMoreTableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
    
    if (!loadMoreCell) {
        loadMoreCell = [[StringrLoadMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
    }
    
    return loadMoreCell;
}




#pragma mark - StringrCommentsTableViewCell Delegate

- (void)tappedCommentorUserProfileImage:(PFUser *)user
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
    
    [profileVC setUserForProfile:user];
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
