//
//  StringrStringTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrStringTableViewController.h"
#import "StringrNavigationController.h"
#import "StringrUtility.h"

#import "StringrDetailViewController.h"
#import "StringrPhotoViewerViewController.h"
#import "StringrProfileViewController.h"
#import "StringrStringCommentsViewController.h"

#import "StringTableCellViewCell.h"
#import "StringFooterTableViewCell.h"

@interface StringrStringTableViewController ()

@property (strong, nonatomic) NSArray *images;

@end

@implementation StringrStringTableViewController

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = self.tabBarController.tabBarItem.title;
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menuButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(showMenu)];
    
    self.tableView.allowsSelection = NO;
    
    
    // Test string array/dictionaries
    self.images = @[ @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article A1", @"image":@"sample_1.jpeg" },
                                            @{ @"title": @"Article A2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article A3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article A4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article A5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article B1", @"image":@"sample_1.jpeg" },
                                            @{ @"title": @"Article B2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article B3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article B4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article B5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article C1", @"image":@"sample_1.jpeg" },
                                            @{ @"title": @"Article C2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article C3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article C4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article C5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article D1", @"image":@"sample_1.jpeg" },
                                            @{ @"title": @"Article D2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article D3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article D4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article D5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article E1", @"image":@"sample_1.jpeg"},
                                            @{ @"title": @"Article E2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article E3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article E4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article E5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         @{ @"description": @"An eternity in Bruges",
                            @"articles": @[ @{ @"title": @"Article F1", @"image":@"sample_1.jpeg" },
                                            @{ @"title": @"Article F2", @"image":@"sample_2.jpeg" },
                                            @{ @"title": @"Article F3", @"image":@"sample_3.jpeg" },
                                            @{ @"title": @"Article F4", @"image":@"sample_4.jpeg" },
                                            @{ @"title": @"Article F5", @"image":@"sample_5.jpeg" }
                                            ]
                            },
                         ];
    
    
    [self.tableView registerClass:[StringTableCellViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];
    
    UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.tableView setBackgroundColor:veryLightGrayColor];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    // Adds observer's for different actions that can be performed by selecting different UIObject's on screen
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfileImage:) name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCommentsButton:) name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectLikesButton:) name:@"didSelectLikesButton" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectProfileImage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCommentsButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectLikesButton" object:nil];
}



#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // This will be set to the amount of strings that are loaded from parse
    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One of the rows is for the footer view
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StringTableViewCell";
    
    UITableViewCell *cell;
    
    // Sets up the table view cell accordingly based around whether it is the
    // string row or the footer
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Gets the dictionary of photo data for this specific string/row
        NSDictionary *stringData = [self.images objectAtIndex:[indexPath section]];
        // Gets the photos for this specific string
        NSArray *imageData = [stringData objectForKey:@"articles"];
        
        
        if ([cell isKindOfClass:[StringTableCellViewCell class]]) {
            StringTableCellViewCell *stringCell = (StringTableCellViewCell *)cell;
            // Sets the photos to the array of photo data for the collection view
            [stringCell setCollectionData:imageData];
            
            return  stringCell;
        }
        
    } else if (indexPath.row == 1) {
        // Sets the table view cell to be the custom footer view
        StringFooterTableViewCell *footerCell = [[StringFooterTableViewCell alloc] init];
        
        [footerCell setStringUploaderName:@"Alonso Holmes"];
        [footerCell setStringUploadDate:@"10 minutes ago"];
        [footerCell setStringUploaderProfileImage:[UIImage imageNamed:@"alonsoAvatar.jpg"]];
        
        return footerCell;
        
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}









#pragma mark - Table View Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.5;
}









#define contentViewWidthPercentage .93

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Section header view, which is used for embedding the content view of the section header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView setAlpha:1];
    
    float xpoint = (headerView.frame.size.width - (headerView.frame.size.width * contentViewWidthPercentage)) / 2;
    CGRect contentHeaderRect = CGRectMake(xpoint, 0, headerView.frame.size.width * contentViewWidthPercentage, 23.5);
    
    // This is the content view, which is a button that will provide user interaction that can take them to
    // the detail view of a string
    UIButton *contentHeaderViewButton = [[UIButton alloc] initWithFrame:contentHeaderRect];
    [contentHeaderViewButton setBackgroundColor:[UIColor whiteColor]];
    [contentHeaderViewButton addTarget:self action:@selector(pushToStringDetailView) forControlEvents:UIControlEventTouchUpInside];
    [contentHeaderViewButton setAlpha:0.92];
    [contentHeaderViewButton setTitle:@"An awesome trip from coast to coast!" forState:UIControlStateNormal];
    [contentHeaderViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [contentHeaderViewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [contentHeaderViewButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    
    [headerView addSubview:contentHeaderViewButton];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // string view
        return 157;
    } else if (indexPath.row == 1) {
        // footer view
        return 52;
    }
    
    return 0;
}








#pragma mark - NSNotification/Action handlers


// Handles the action when a cell from a string is selected this will push to the appropriate VC
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    
    if (cellData)
    {
        StringrPhotoViewerViewController *photoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerVC"];
        
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

// Handles the action of pushing to a selected user's profile
- (void)didSelectProfileImage:(NSNotification *)notification
{
    StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
    [profileVC setCanGoBack:YES];
    [profileVC setCanEditProfile:NO];
    [profileVC setTitle:@"User Profile"];
    //[profileVC setCanCloseModal:YES];
    
    
    [self.navigationController pushViewController:profileVC animated:YES];
    
    // Implements modal transition to profile view
//    StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
//    [self presentViewController:navVC animated:YES completion:nil];
}



// Handles the action of pushing to the comment's of a selected string
- (void)didSelectCommentsButton:(NSNotification *)notification
{
    StringrStringCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringCommentsVC"];
    
    [self.navigationController pushViewController:commentsVC animated:YES];
}

// Handles the action of liking the selected string
- (void)didSelectLikesButton:(NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked String"
                                                    message:@"You have liked this String!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

// Handles the action of pushing to to the detail view of a selected string
- (void)pushToStringDetailView
{
  //  UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    
   // detailVC.modalPresentationStyle = UIModalPresentationCustom;
    //detailVC.modalTransitionStyle = UIModalPresentationNone;
    
    // default present is modal animation
    //[navigationController presentViewController:detailVC animated:YES completion:NULL];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

// Handles the action of displaying the menu when the menu nav item is pressed
- (void)showMenu
{
    [StringrUtility showMenu:self.frostedViewController];
} 

@end
