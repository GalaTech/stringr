//
//  StringrStringCommentsViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 12/28/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrCommentsTableViewController.h"
#import "StringrNavigationController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewCell.h"
#import "StringrWriteCommentViewController.h"
#import "StringrPathImageView.h"
#import "StringrLoadMoreTableViewCell.h"
#import "StringrWriteAndEditTextViewController.h"
#import "StringrSearchTableViewController.h"
#import "UIColor+StringrColors.h"

@interface StringrCommentsTableViewController () <UINavigationControllerDelegate, StringrCommentsTableViewCellDelegate, StringrWriteCommentDelegate>

@property (strong, nonatomic) NSMutableArray *commentsThread;

@property (weak, nonatomic) StringrWriteCommentViewController *writeCommentVC;
@property (weak, nonatomic) StringrCommentsTableViewCell *commentsTableVC;
@property (weak, nonatomic) StringrProfileViewController *profileVC;
@property (weak, nonatomic) StringrNavigationController *navigationVC;
@property (strong, nonatomic) NSMutableArray *commentUsers;

@end

@implementation StringrCommentsTableViewController

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
    [self.tableView setBackgroundColor:[UIColor stringTableViewBackgroundColor]];
    
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
    
    // Either self is set to edit comments or the comment row at indexPath is owned by the current user
    return self.commentsEditable || [rowObjectId isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *commentToRemove = [self.objects objectAtIndex:indexPath.row];
        
        PFQuery *commentMentionsQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [commentMentionsQuery whereKey:kStringrActivityCommentKey equalTo:commentToRemove];
        [commentMentionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [PFObject deleteAllInBackground:objects];
            
            [commentToRemove deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.objectForCommentThread saveInBackground];
                    [self loadObjects];
                }
            }];
        }];
        
        
        
        [[StringrCache sharedCache] decrementCommentCountForObject:self.objectForCommentThread];
        
        // decrement associated string statistic number of comments
        if ([StringrUtility objectIsString:self.objectForCommentThread]) {
            PFObject *stringStatistics = [self.objectForCommentThread objectForKey:kStringrStringStatisticsKey];
            [stringStatistics incrementKey:kStringrStatisticsCommentCountKey byAmount:@(-1)];
            [stringStatistics saveEventually];
        }
        
        if ([self.delegate respondsToSelector:@selector(commentsTableView:didChangeCommentCountInSection:)]) {
            [self.delegate commentsTableView:self didChangeCommentCountInSection:self.section];
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
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
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
    
    if (self.objects.count == 0) {
        StringrNoContentView *noContentHeaderView = [[StringrNoContentView alloc] initWithNoContentText:@"There are no Comments"];
        [noContentHeaderView setTitleForExploreOptionButton:@"Why don't you add the first one?"];
        [noContentHeaderView setDelegate:self];
        
        self.tableView.tableHeaderView = noContentHeaderView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
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

- (void)tableViewCell:(StringrCommentsTableViewCell *)commentsCell tappedUserHandleWithName:(NSString *)name
{
    PFQuery *findUserQuery = [PFUser query];
    [findUserQuery whereKey:kStringrUserUsernameKey equalTo:name];
    [findUserQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (!error) {
            if (users.count > 0) {
                PFUser *user = [users firstObject];
                
                StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardProfileID];
                [profileVC setUserForProfile:user];
                [profileVC setProfileReturnState:ProfileModalReturnState];
                
                StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
                [self presentViewController:navVC animated:YES completion:nil];
            } else {
                NSLog(@"No user with that name was found!");
            }
        }
    }];
}

- (void)tableViewCell:(StringrCommentsTableViewCell *)commentsCell tappedHashtagWithText:(NSString *)hashtag
{
    StringrSearchTableViewController *searchStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardSearchStringsID];
    [searchStringsVC searchStringsWithText:hashtag];
    
    searchStringsVC.navigationItem.leftBarButtonItem = nil;
    searchStringsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    [self.navigationController pushViewController:searchStringsVC animated:YES];
}



#pragma mark - StringrWriteComment Delegate

- (void)commentViewController:(StringrWriteCommentViewController *)commentView didPostComment:(PFObject *)comment
{
    [self loadObjects];
    
    if ([self.delegate respondsToSelector:@selector(commentsTableView:didChangeCommentCountInSection:)]) {
        [self.delegate commentsTableView:self didChangeCommentCountInSection:self.section];
    }
}

- (void)commentViewControllerDidCancel:(StringrWriteCommentViewController *)commentView
{
    
}



#pragma mark - StringrNoContentView Delegate

- (void)noContentView:(StringrNoContentView *)noContentView didSelectExploreOptionButton:(UIButton *)exploreButton
{
    [self writeComment];
}


@end
