//
//  StringrTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/16/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrTableViewController.h"
#import "StringrStringDetailViewController.h"

@interface StringrTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Private

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}




#pragma mark - Custom Accessor's/Public

- (void)setQueryForTable:(PFQuery *)queryForTable
{
    _providedQueryForTable = queryForTable;
    
}

- (PFQuery *)getQueryForTable
{
    return _providedQueryForTable;
}




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
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        
        
        UIImagePickerController *imagePickerController= [[UIImagePickerController alloc]init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        // image picker needs a delegate so we can respond to its messages
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 2) { // supposed to be for returning to saved string
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }
}




#pragma mark - UIImagePicker Delegate

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        StringrStringDetailViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stringDetailVC"];
        [newStringVC setStringToLoad:nil];
        [newStringVC setEditDetailsEnabled:YES];
        [newStringVC setUserSelectedPhoto:image];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
    }];
}


@end
