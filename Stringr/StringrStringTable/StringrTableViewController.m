//
//  StringrTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrTableViewController.h"
#import "StringrStringDetailViewController.h"
#import "StringrActivityTableViewController.h"
#import "StringrNavigationController.h"
#import "ZCImagePickerController.h"

@interface StringrTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZCImagePickerControllerDelegate>

@property (strong, nonatomic) PFQuery *providedQueryForTable;

@end

@implementation StringrTableViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNotification:) name:kNSNotificationCenterApplicationDidReceiveRemoteNotification object:nil];
    
    // Sets the back button to have no text, just the <
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    // Adds observer's for different actions that can be performed by selecting different UIObject's on screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewString) name:kNSNotificationCenterUploadNewStringKey object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterUploadNewStringKey object:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterApplicationDidReceiveRemoteNotification object:nil];
}


#pragma mark - Custom Accessors

- (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle: nil];
}


#pragma mark - Public

- (void)setQueryForTable:(PFQuery *)queryForTable
{
    _providedQueryForTable = queryForTable;
    
}

- (PFQuery *)getQueryForTable
{
    return _providedQueryForTable;
}


#pragma mark - Private

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions

/*
- (void)handlePushNotification:(NSNotification *)note
{
    NSDictionary *pushNotificationDeatils = note.userInfo;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(closeModal)];

    StringrActivityTableViewController *activityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"activityVC"];
    [activityVC setTitle:@"Activity"];
    [activityVC setHidesBottomBarWhenPushed:YES];
    
    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:activityVC];
    [navVC.navigationItem setLeftBarButtonItem:closeButton];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

*/

/* Navigation bar scrolls along with table view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
//    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}
 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (void)addNewString
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Create New String"
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
    
    [newStringActionSheet addButtonWithTitle:@"Take Photo"];
    [newStringActionSheet addButtonWithTitle:@"Choose from Existing"];
    
    [newStringActionSheet addButtonWithTitle:@"Cancel"];
    [newStringActionSheet setCancelButtonIndex:[newStringActionSheet numberOfButtons] - 1];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [newStringActionSheet showInView:self.view];
    } else {
        [newStringActionSheet showInView:window];
    }
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [imagePickerController setDelegate:self];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Existing"]) {
        ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
        imagePickerController.imagePickerDelegate = self;
        imagePickerController.maximumAllowsSelectionCount = 50;
        imagePickerController.mediaType = ZCMediaAllPhotos;
        [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}


#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        StringrStringDetailViewController *newStringVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setStringToLoad:nil]; // set to nil because we don't have a string yet.
        [newStringVC setEditDetailsEnabled:YES];
        [newStringVC setUserSelectedPhoto:image];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}


#pragma mark - ZCImagePickerController Delegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDict in info) {
        UIImage *image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        
        NSLog(@"%@", [imageDict description]);
        
        [images addObject:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        StringrStringDetailViewController *newStringVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setStringToLoad:nil]; // set to nil because we don't have a string yet.
        [newStringVC setEditDetailsEnabled:YES];
        
        if (images && images.count <= 1)
        {
            [newStringVC setUserSelectedPhoto:images[0]];
        } else if (images)
        {
            [newStringVC setUserSelectedPhotos:images];
        }
        
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}

- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
