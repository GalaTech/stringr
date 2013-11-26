//
//  StringrMenuViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMenuViewController.h"

#import "StringrProfileViewController.h"
#import "StringrMyStringsViewController.h"
#import "StringrLikedStringsViewController.h"

#import "StringrStringDiscoveryTabBarViewController.h"
#import "StringrMySchoolViewController.h"
#import "StringrSearchViewController.h"

#import "StringrSettingsViewController.h"
#import "StringrLoginViewController.h"

#import "UIViewController+REFrostedViewController.h"

@interface StringrMenuViewController ()

@end

@implementation StringrMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO; // Allows transparency
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"orca-stock-photo.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Jed Erbar";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    /*
     * Adds a footer to the table view, which I will probably use for a settings and logout button
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"orca-stock-photo.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Jed Erbar";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
     */
    
}

#pragma mark -
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
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    
    // Table section 0 menu items actions
    if (indexPath.section == 0 && indexPath.row == 0) {
        StringrProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
        profileVC.canEditProfile = YES;
        navigationController.viewControllers = @[profileVC];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        StringrMyStringsViewController *myStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyStringsVC"];
        navigationController.viewControllers = @[myStringsVC];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        StringrLikedStringsViewController *likedStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikedStringsVC"];
        navigationController.viewControllers = @[likedStringsVC];
    }
    
    // Table section 1 menu items actions
    if (indexPath.section == 1 && indexPath.row == 0) {
        StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
        navigationController.viewControllers = @[stringDiscoveryVC];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        StringrMySchoolViewController *mySchoolVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MySchoolTabBar"];
        navigationController.viewControllers = @[mySchoolVC];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        StringrSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTabBar"];
        navigationController.viewControllers = @[searchVC];
    }
    
    //Table section 2 menu items actions
    if (indexPath.section == 2 && indexPath.row == 0) {
        StringrSettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
        navigationController.viewControllers = @[settingsVC];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        StringrLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        navigationController.viewControllers = @[loginVC];
    }
    
    
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
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
