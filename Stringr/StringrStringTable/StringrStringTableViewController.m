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

#import "StringTableCellViewCell.h"
#import "StringFooterTableViewCell.h"

@interface StringrStringTableViewController ()

@property (strong, nonatomic) NSArray *images;

@end

@implementation StringrStringTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // Creates the navigation item to access the menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered target:self
                                                                            action:@selector(showMenu)];
    
    self.tableView.allowsSelection = NO;
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];

    
    /* Creates a header view for the entire table view. This could be an alternate
     * method for setting up user profile's
     *
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    [tableHeaderView setBackgroundColor:[UIColor purpleColor]];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 50, 100, 20)];
    [headerButton setTitle:@"Test Button" forState:UIControlStateNormal];
    [headerButton setTitle:@"Pressed Button" forState:UIControlStateHighlighted | UIControlStateSelected];
    
    [tableHeaderView addSubview:headerButton];
    
    self.tableView.tableHeaderView = tableHeaderView;
    */
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}




#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StringTableViewCell";
    static NSString *footerIdentifier = @"StringTableViewFooter";
    
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
        // Sets background to same tableview bg color
       // UIColor *veryLightGrayColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        /*
        cell = [tableView dequeueReusableCellWithIdentifier:footerIdentifier];
        [cell.contentView setBackgroundColor:veryLightGrayColor];
        */
        
        
        // Sets the table view cell to be the custom footer view
        StringFooterTableViewCell *footerCell = [[StringFooterTableViewCell alloc] init];
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

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionData = [self.images objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"description"];
    return header;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // last section in table will not have the extra footer view margin
    if (section == [self.images count] - 1) {
        return 35;
    }
    
    return 48;
}
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Section header view, which is used for embedding the content view of the section header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView setAlpha:1];

    // The content view for the section header, which contains the title for a string
    UIView *contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width * .875, 20)];
    [contentHeaderView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:contentHeaderView];
    
    
    //NSMutableAttributedString *stringHeaderTitle = [[NSMutableAttributedString alloc] initWithString:@"An awesome trip from coast to coast!"];
    
    //[stringHeaderTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:12] range:NSMakeRange(0, 21)];
    //[stringHeaderTitle addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 21)];
    
    CGRect labelWidth = CGRectMake(0, 1.5, contentHeaderView.frame.size.width, 16);
    UILabel *stringHeaderTitle = [[UILabel alloc] initWithFrame:labelWidth];
    [stringHeaderTitle setText:@"An awesome trip from coast to coast!"];
    [stringHeaderTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [stringHeaderTitle setTextColor:[UIColor darkGrayColor]];
    [stringHeaderTitle setTextAlignment:NSTextAlignmentCenter];
    
    
    //[stringHeaderTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:11] range:NSMakeRange(21, 16)];
    //[stringHeaderTitle addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(21, 16)];
    
    //UILabel *stringTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, tableView.frame.size.width, 16)];
    
    //[stringTitleLabel setAttributedText:stringHeaderTitle];
    [contentHeaderView addSubview:stringHeaderTitle];
    
    
    
    return headerView;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *contentFooterView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, footerView.frame.size.width * .875, 35)];
    [contentFooterView setBackgroundColor:[UIColor whiteColor]];
    [contentFooterView setAlpha:1];
    [footerView addSubview:contentFooterView];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    [footerLabel setText:@"Test footer label"];
    [contentFooterView addSubview:footerLabel];
    
    return footerView;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135;
    } else if (indexPath.row == 1) {
        return 48;
    }
    
    return 0;
}


#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    
    if (cellData)
    {
        StringrPhotoViewerViewController *photoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerVC"];
        
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}



@end
