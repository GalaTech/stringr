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

@interface StringrStringCommentsViewController () <UINavigationControllerDelegate, StringrCommentsTableViewCellDelegate, StringrWriteCommentDelegate>

@property (strong, nonatomic) NSMutableArray *commentsThread;

@property (strong, nonatomic) StringrWriteCommentViewController *writeCommentVC;
@property (strong, nonatomic) StringrCommentsTableViewCell *commentsTableVC;
@property (strong, nonatomic) StringrProfileViewController *profileVC;
@property (strong, nonatomic) StringrNavigationController *navigationVC;

@end

@implementation StringrStringCommentsViewController

#pragma mark - Lifecycle


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = kStringrActivityClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
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
    
    /*
    // lazy loads the navigationVC for easy external VC presentation
    if (!self.navigationVC) {
        self.navigationVC = [[StringrNavigationController alloc] init];
    }
     */
    
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

- (NSMutableArray *)commentsThread
{
    if (!_commentsThread) {
        _commentsThread = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            /*
            NSString *commentText = @"A block quotation (also known as a long quotation or extract) is a quotation in a written document, that is set off from the main text as a paragraph, or block of text, and typically distinguished visually using indentation and a different typeface or smaller size quotation. (This is in contrast to a setting it off with quotation marks in a run-in quote.) Block quotations are used for the long quotation. The Chicago Manual of Style recommends using a block quotation when extracted text is 100 words or more, or at least eight lines.";
            */
             
            NSDictionary *comment = @{@"profileImage" : @"stringr_icon_filler", @"profileDisplayName" : @"Alonso Holmes", @"uploadDate" : @"3 min ago", @"commentText" : @"It looks like you had an amazing trip!"};
            
            [_commentsThread addObject:comment];
        }
    }
    
    return _commentsThread;
}


#pragma mark - Actions

- (void)writeComment
{
    StringrWriteCommentViewController *writeCommentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"writeCommentVC"];
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
                
                if ([self.objectForCommentThread.parseClassName isEqualToString:kStringrStringClassKey]) {
                    [self.objectForCommentThread incrementKey:kStringrStringNumberOfCommentsKey byAmount:@(-1)];
                } else if ([self.objectForCommentThread.parseClassName isEqualToString:kStringrPhotoClassKey]) {
                    [self.objectForCommentThread incrementKey:kStringrPhotoNumberOfCommentsKey byAmount:@(-1)];
                }
                
                [self.objectForCommentThread saveInBackground];
                [self loadObjects];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.objects.count) {
        return 45.0f;
    }
    
    return 100.0f;
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
    
    
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
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
            [commentsCell.commentsProfileDisplayName setText:[user objectForKey:kStringrUserDisplayNameKey]];
            
            UIActivityIndicatorView *loadingProfileImageActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            float width = CGRectGetWidth(commentsCell.commentsProfileImage.frame) / 2;
            float height = CGRectGetHeight(commentsCell.commentsProfileImage.frame) / 2;
            [loadingProfileImageActivityIndicator setCenter:CGPointMake(width, height)];
            [commentsCell.commentsProfileImage addSubview:loadingProfileImageActivityIndicator];
            [loadingProfileImageActivityIndicator startAnimating];
            
            PFFile *profileImageFile = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
            [commentsCell.commentsProfileImage setFile:profileImageFile];
            [commentsCell.commentsProfileImage loadInBackground:^(UIImage *image, NSError *error) {
                if (!error) {
                    [loadingProfileImageActivityIndicator stopAnimating];
                }
            }];
        }];
        
        return commentsCell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    PFTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
    [loadCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    return loadCell;
}



#pragma mark - StringrCommentsTableViewCell Delegate

- (void)tappedCommentorProfileImage
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    [profileVC setUserForProfile:[PFUser currentUser]];
    [profileVC setProfileReturnState:ProfileModalReturnState];
    
    //[self.navigationController pushViewController:profileVC animated:YES];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}




#pragma mark - StringrWriteComment Delegate

- (void)reloadCommentTableView
{
    [self loadObjects];
}


@end
