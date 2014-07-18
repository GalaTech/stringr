//
//  StringrStringEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/25/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailViewController.h"
#import "StringrStringDetailTableViewController.h"
#import "StringrStringDetailEditTableViewController.h"
#import "StringrStringDetailTopViewController.h"
#import "StringrStringDetailEditTopViewController.h"
#import "StringrProfileViewController.h"
#import "StringrCommentsTableViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrNavigationController.h"
#import "ZCImagePickerController.h"

@interface StringrStringDetailViewController () <UIAlertViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, StringrStringDetailEditTableViewControllerDelegate, StringrStringDetailEditTopViewControllerDelegate, ZCImagePickerControllerDelegate>

@property (weak, nonatomic) StringrStringDetailTopViewController *stringTopVC;
@property (weak, nonatomic) StringrStringDetailTableViewController *stringTableVC;

@end

@implementation StringrStringDetailViewController

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self.stringToLoad fetchIfNeededInBackgroundWithBlock:^(PFObject *stringObject, NSError *error) {
        //if (!error) {
            //self.stringToLoad = stringObject;
            self.stringTopVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailTopViewID];
            [self.stringTopVC setStringToLoad:self.stringToLoad];
            
            self.stringTableVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardStringDetailTableViewID];
            [self.stringTableVC setStringDetailsToLoad:self.stringToLoad];
            
            if (self.editDetailsEnabled) {
                self.title = @"Publish String";
                
                UIBarButtonItem *publishStringButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"upload_button"]
                                                                                        style:UIBarButtonItemStyleBordered
                                                                                       target:self
                                                                                       action:@selector(saveAndPublishString)];
                
                UIBarButtonItem *addNewPhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPhoto)];
                [self.navigationItem setRightBarButtonItems:@[publishStringButton, addNewPhotoButton]  animated:NO];
                
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"]
                                                                                         style:UIBarButtonItemStyleBordered
                                                                                        target:self
                                                                                        action:@selector(returnToPreviousScreen)];
                
                
                // notice that there is explicit casting for these classes.
                self.stringTopVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEditStringDetailTopViewID];
                [(StringrStringDetailEditTopViewController *)self.stringTopVC setUserSelectedPhoto:self.userSelectedPhoto];
                [(StringrStringDetailEditTopViewController *)self.stringTopVC setUserSelectedPhotos:self.userSelectedPhotos];
                [(StringrStringDetailEditTopViewController *)self.stringTopVC setStringToLoad:self.stringToLoad];
                [(StringrStringDetailEditTopViewController *)self.stringTopVC setDelegate:self];
                
                self.stringTableVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardEditStringDetailTableViewID];
                [self.stringTableVC setStringDetailsToLoad:self.stringToLoad];
                [self.stringTableVC setEditDetailsEnabled:YES];
                
                StringrStringDetailEditTableViewController *tableVC = (StringrStringDetailEditTableViewController *)self.stringTableVC;
                [tableVC setDelegate:self];
                
                [(StringrStringDetailEditTableViewController *)self.stringTableVC setDelegate:(StringrStringDetailEditTopViewController *)self.stringTopVC];
            } else {
                self.title = @"String Details";
                
                if ([self.stringToLoad.ACL getPublicWriteAccess]) {
                    UIBarButtonItem *addNewPhotoToPublicString = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPhoto)];
                    self.navigationItem.rightBarButtonItem = addNewPhotoToPublicString;
                }
            }
            
            [self setupWithTopViewController:self.stringTopVC andTopHeight:283 andBottomViewController:self.stringTableVC];
            
            self.maxHeightBorder = CGRectGetHeight(self.view.frame);
            [self enableTapGestureTopView:NO];
    
       // }
  //  }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)dealloc
{
    NSLog(@"dealloc string detail");
}


//*********************************************************************************/
#pragma mark - Actions
//*********************************************************************************/

- (void)saveAndPublishString
{
    StringrStringDetailEditTopViewController *topVC = (StringrStringDetailEditTopViewController *)self.stringTopVC;
    [topVC saveString];
}

- (void)addNewPhoto
{
    UIActionSheet *newStringActionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Photo to String" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    
    [newStringActionSheet showInView:self.view];
}

- (void)returnToPreviousScreen
{
    UIAlertView *cancelStringAlert = [[UIAlertView alloc] initWithTitle:@"Cancel String"
                                                                message:@"Are you sure that you want to cancel?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", /*@"Save for Later",*/ nil];
    [cancelStringAlert show];
    
    StringrStringDetailEditTopViewController *topVC = (StringrStringDetailEditTopViewController *)self.stringTopVC;
    [topVC cancelString];
}



//*********************************************************************************/
#pragma mark - UIAlertView Delegate
//*********************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:kNSUserDefaultsWorkingStringSavedImagesKey];
        [defaults synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    /*
    else if (buttonIndex == 2) {
        // Set the delegate to parentViewController so that it will properly be handled after the navigation has moved back to that VC
        UIAlertView *stringSavedAlert = [[UIAlertView alloc] initWithTitle:@"String Saved!" message:@"Your string has been saved for future editing." delegate:self.parentViewController cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [stringSavedAlert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
     */
}



//*********************************************************************************/
#pragma mark - UIActionSheet Delegate
//*********************************************************************************/

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        // image picker needs a delegate,
        [imagePickerController setDelegate:self];
        
        // Place image picker on the screen
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Library"]) {

        if (self.editDetailsEnabled) {
            ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
            imagePickerController.imagePickerDelegate = self;
            imagePickerController.maximumAllowsSelectionCount = 10;
            imagePickerController.mediaType = ZCMediaAllPhotos;
            [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
            
        } else {
             UIImagePickerController *imagePickerController= [[UIImagePickerController alloc]init];
             [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
             
             // image picker needs a delegate so we can respond to its messages
             [imagePickerController setDelegate:self];
             
             // Place image picker on the screen
             [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        

    }
}



//*********************************************************************************/
#pragma mark - UIImagePicker Delegate
//*********************************************************************************/

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^ {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (self.editDetailsEnabled) {
            StringrStringDetailTableViewController *tableVC = (StringrStringDetailTableViewController *)self.stringTableVC;
            [tableVC.tableView setUserInteractionEnabled:NO];
            
            StringrStringDetailEditTopViewController *topVC = (StringrStringDetailEditTopViewController *)self.stringTopVC;
            [topVC setUserSelectedPhoto:image]; // proceeds to create and new PF photo object and presents photo edit view
 
        } else { // Public
            StringrStringDetailTableViewController *tableVC = (StringrStringDetailTableViewController *)self.stringTableVC;
            [tableVC.tableView setUserInteractionEnabled:NO];
            
            StringrStringDetailTopViewController *topVC = (StringrStringDetailTopViewController *)self.stringTopVC;
            [topVC addImageToString:image withBlock:^(BOOL succeeded, PFObject *photo, NSError *error) {
                if (succeeded) {
                    
                    StringrPhotoDetailViewController *editPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
                    [editPhotoVC setEditDetailsEnabled:YES];
                    [editPhotoVC setStringOwner:self.stringToLoad];
                    [editPhotoVC setSelectedPhotoIndex:0];
                    [editPhotoVC setPhotosToLoad:@[photo]];
                    
                    if ([self.stringToLoad.ACL getPublicWriteAccess]) {
                        editPhotoVC.isPublicPhoto = YES;
                    }
                    
                    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:editPhotoVC];
                    
                    [self presentViewController:navVC animated:YES completion:nil];
                }
            }];
        }
    }];
}


//*********************************************************************************/
#pragma mark - ZCImagePickerController Delegate
//*********************************************************************************/

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSDictionary *imageDict in info) {
        UIImage *image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        
        [images addObject:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        StringrStringDetailEditTopViewController *topVC = (StringrStringDetailEditTopViewController *)self.stringTopVC;
        
        if (images.count <= 1) {
            [topVC setUserSelectedPhoto:[images firstObject]]; //
        } else {
            [topVC setUserSelectedPhotos:images];
        }
    }];
}

- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



//*********************************************************************************/
#pragma mark - StringrStringDetailEditTopViewController Delegate
//*********************************************************************************/

- (void)toggleActionEnabledOnTableView:(BOOL)enabled
{
    StringrStringDetailTableViewController *tableVC = (StringrStringDetailTableViewController *)self.stringTableVC;
    [tableVC.tableView setUserInteractionEnabled:enabled];
}



//*********************************************************************************/
#pragma mark - Parallax Delegate
//*********************************************************************************/

/**
 * Callback when the top height changed
 */
- (void) parallaxScrollViewController:(QMBParallaxScrollViewController *) controller didChangeTopHeight:(CGFloat) height
{
    NSLog(@"%f", height);
}


- (void)changeTopHeightOfParallax
{
    [self changeTopHeight:0.0f];
}



@end
