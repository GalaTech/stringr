//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrUtility.h"

#import "StringrDetailViewController.h"
#import "StringrPhotoViewerViewController.h"

@interface StringrStringTableViewController ()

@end

@implementation StringrStringTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered target:self
                                                                            action:@selector(showMenu)];
}

- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
}


- (IBAction)pushToStringDetailView:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    detailVC.modalTransitionStyle = UIModalPresentationNone;
    
    // default present is modal animation
    //[navigationController presentViewController:detailVC animated:YES completion:NULL];
    
    
    [navigationController pushViewController:detailVC animated:YES];
}


- (IBAction)pushToPhotoViewer:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrPhotoViewerViewController *photoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerVC"];
    
    [navigationController pushViewController:photoVC animated:YES];
}

@end
