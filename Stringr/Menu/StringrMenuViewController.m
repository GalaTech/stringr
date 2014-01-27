//
//  StringrMenuViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMenuViewController.h"
#import "StringrNavigationController.h"

#import "StringrProfileViewController.h"
#import "StringrMyStringsTableViewController.h"
#import "StringrLikedStringsTableViewController.h"

#import "StringrDiscoveryTabBarViewController.h"
#import "StringrMySchoolTabBarViewController.h"
#import "StringrSearchTabBarViewController.h"

#import "StringrStringEditViewController.h"

#import "StringrSettingsViewController.h"
#import "StringrLoginViewController.h"

#import "UIViewController+REFrostedViewController.h"
#import "StringrPathImageView.h"

#import "AppDelegate.h"


@interface StringrMenuViewController () <UIActionSheetDelegate>

@property (strong,nonatomic) UIButton *cameraButton;

@end

@implementation StringrMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO; // Allows transparency
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Creates the header of the menu that contains profile image and other graphics
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 20, 25, 25)];
    [self.cameraButton setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 30, 30)];
    [cameraImage setImage:[UIImage imageNamed:@"following.png"]];
    
    //cameraImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    StringrPathImageView *imageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)
                                                                            image:[UIImage imageNamed:@"alonsoAvatar.jpg"]
                                                                        pathColor:[UIColor darkGrayColor]
                                                                        pathWidth:1.0];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    label.text = @"Alonso Holmes";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:imageView];
    [view addSubview:self.cameraButton];
    [view addSubview:label];
    
    self.tableView.tableHeaderView = view;
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
}




#pragma mark - Action Handlers

- (void)cameraButtonPushed:(UIButton *)sender
{
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadNewString" object:nil];
    
    
    //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Create String" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    //[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    //[actionSheet showInView:self.parentViewController.view];
}




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        StringrStringEditViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        
        
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
        */
    } else if (buttonIndex == 1) {
        StringrStringEditViewController *newStringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
        [newStringVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newStringVC animated:YES];
        
        
        // Modal
        /*
         StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:newStringVC];
         
         [self presentViewController:navVC animated:YES completion:nil];
         */
    }
}




#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    // Creates a custom menu section header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    
    // Set the section header text based off of what section it is
    switch (sectionIndex) {
        case 1:
            label.text = @"Discover";
            break;
        case 2:
            label.text = @"Settings";
            break;
        default:
            label.text = @"";
    }
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Instance of our navigation controller, which is the frostedVC
    //UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    
    // Table section 0 menu items actions
    if (indexPath.section == 0 && indexPath.row == 0) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
        profileVC.canEditProfile = YES;
        profileVC.title = @"My Profile";
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:profileVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        StringrMyStringsTableViewController *myStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyStringsVC"];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:myStringsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        StringrLikedStringsTableViewController *likedStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikedStringsVC"];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:likedStringsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    }
    
    // Table section 1 menu items actions
    if (indexPath.section == 1 && indexPath.row == 0) {
        StringrDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
        
        [self.frostedViewController setContentViewController:stringDiscoveryVC];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        StringrMySchoolTabBarViewController *mySchoolVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MySchoolTabBar"];
        
        [self.frostedViewController setContentViewController:mySchoolVC];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        StringrSearchTabBarViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTabBar"];
        
        [self.frostedViewController setContentViewController:searchVC];
    }
    
    //Table section 2 menu items actions
    if (indexPath.section == 2 && indexPath.row == 0) {
        StringrSettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:settingsVC];
        
        [self.frostedViewController setContentViewController:navVC];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        // Makes it so that when you dismiss the main VC it won't also perform the close menu animation
        return;
    }
    
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
}




#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 3;
    } else if (sectionIndex == 1) {
        return 3;
    } else if (sectionIndex == 2) {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    /*
    if (indexPath.section == 0) {
        NSArray *titles = @[@"My Profile", @"My Strings", @"My School", @"Liked Strings"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Stringr Discovery", @"Search", @"Settings", @"Logout"];
        cell.textLabel.text = titles[indexPath.row];
    }
     */
    
    NSArray *titles;
    
    switch (indexPath.section) {
        case 0:
            titles = @[@"My Profile", @"My Strings", @"Liked Strings"];
            break;
        case 1:
            titles = @[@"Stringr Discovery", @"My School", @"Search"];
            break;
        case 2:
            titles = @[@"Settings", @"Logout"];
            break;
    }
    
    cell.textLabel.text = titles[indexPath.row];
    
    
    
    return cell;
}

@end
