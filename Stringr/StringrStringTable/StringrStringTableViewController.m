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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StringTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *stringData = [self.images objectAtIndex:[indexPath section]];
    NSArray *imageData = [stringData objectForKey:@"articles"];
    
    
    if ([cell isKindOfClass:[StringTableCellViewCell class]]) {
        StringTableCellViewCell *stringCell = (StringTableCellViewCell *)cell;
        
        [stringCell setCollectionData:imageData];
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark - Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionData = [self.images objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"description"];
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
