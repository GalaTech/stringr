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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Comments";
    
    [self.tableView setScrollsToTop:YES];
    [self.tableView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeComment)];
    
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
             
            NSDictionary *comment = @{@"profileImage" : @"Stringr Image", @"profileDisplayName" : @"Alonso Holmes", @"uploadDate" : @"3 min ago", @"commentText" : @"It looks like you had an amazing trip!"};
            
            [_commentsThread addObject:comment];
        }
    }
    
    return _commentsThread;
}


#pragma mark - Actions

- (void)writeComment
{
    /*
    if (!self.writeCommentVC) {
        self.writeCommentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"writeCommentVC"];
    }
    
    [self.navigationVC setViewControllers:@[self.writeCommentVC]];
    [self.navigationVC setDelegate:self];
     */
    
    StringrWriteCommentViewController *writeCommentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"writeCommentVC"];
    [writeCommentVC setDelegate:self];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:writeCommentVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}



#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentsThread count];
}

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




#pragma mark - TableView Delegate

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    [headerView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UIColor *countourLineColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    UIColor *lightContourLineColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    UIImageView *topContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1)];
    [topContourLine setBackgroundColor:countourLineColor];
    
    UIImageView *bottomContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, CGRectGetWidth(self.view.frame), 1)];
    [bottomContourLine setBackgroundColor:lightContourLineColor];
    
    [headerView addSubview:topContourLine];
    [headerView addSubview:bottomContourLine];
    
    
    return headerView;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
 */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.commentsEditable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.commentsThread removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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

- (void)pushSavedComment:(NSDictionary *)comment
{
    [self.commentsThread insertObject:comment atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //[self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
    
    //[self.tableView reloadData];
}

@end
