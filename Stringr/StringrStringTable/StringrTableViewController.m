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

@interface StringrTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZCImagePickerControllerDelegate>

@property (strong, nonatomic) PFQuery *providedQueryForTable;

@end

@implementation StringrTableViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc table view");
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

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}

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
    
    /* Implement return to saved string
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     if (![defaults objectForKey:kUserDefaultsWorkingStringSavedImagesKey]) {
     [newStringActionSheet addButtonWithTitle:@"Return to Saved String"];
     [newStringActionSheet setDestructiveButtonIndex:[newStringActionSheet numberOfButtons] - 1];
     }
     */
    
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
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        [actionSheet resignFirstResponder];
    } else if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [imagePickerController setDelegate:self];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
        imagePickerController.imagePickerDelegate = self;
        imagePickerController.maximumAllowsSelectionCount = 10;
        imagePickerController.mediaType = ZCMediaAllPhotos;
        [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
        
    } else if (buttonIndex == 2) { // supposed to be for returning to saved string
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
}




#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
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
        
        [images addObject:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailID];
        [newStringVC setStringToLoad:nil]; // set to nil because we don't have a string yet.
        [newStringVC setEditDetailsEnabled:YES];
        
        if (images.count <= 1) {
            [newStringVC setUserSelectedPhoto:images[0]];
        } else {
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
