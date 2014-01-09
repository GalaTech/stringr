//
//  StringrMenuViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/20/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrMenuViewController.h"

#import "StringrProfileViewController.h"
#import "StringrMyStringsTableViewController.h"
#import "StringrLikedStringsTableViewController.h"

#import "StringrStringDiscoveryTabBarViewController.h"
#import "StringrMySchoolViewController.h"
#import "StringrSearchViewController.h"

#import "StringrStringEditViewController.h"

#import "StringrSettingsViewController.h"
#import "StringrLoginViewController.h"

#import "UIViewController+REFrostedViewController.h"
#import "GBPathImageView.h"

@interface StringrMenuViewController () <UIActionSheetDelegate>

@property (strong,nonatomic) UIButton *cameraButton;

@end

@implementation StringrMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO; // Allows transparency
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
        
        self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 20, 25, 25)];
        [self.cameraButton setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
        
        [self.cameraButton addTarget:self action:@selector(cameraButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 30, 30)];
        [cameraImage setImage:[UIImage imageNamed:@"following.png"]];
        
        //cameraImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        // Creates the circular profile image in the slide out menu
        GBPathImageView *imageView = [[GBPathImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)
                                                                      image:[UIImage imageNamed:@"alonsoAvatar.jpg"]
                                                                   pathType:GBPathImageViewTypeCircle
                                                                  pathColor:[UIColor whiteColor]
                                                                borderColor:[UIColor whiteColor]
                                                                  pathWidth:3.0];
        
        // Sets the auto resizing for both the left and right margins.
        // This will automatically add the center to the center of the view.
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        /* Original version of adding the profile image to the view
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
        */
         
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Jed Erbar";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:self.cameraButton];
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

- (IBAction)cameraButtonPushed:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrStringEditViewController *stringEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringEditVC"];
    
    
    //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Create String" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from Library", nil];
    
    
    
//    UIView *view = [[]
    
    //[actionSheet showInView:self.view];
    
    
    [navigationController pushViewController:stringEditVC animated:NO];
    
    
    // Closes the menu after we move to a new VC
    [self.frostedViewController hideMenuViewController];
    
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
        profileVC.title = @"My Profile";
        navigationController.viewControllers = @[profileVC];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        StringrMyStringsTableViewController *myStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyStringsVC"];
        navigationController.viewControllers = @[myStringsVC];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        StringrLikedStringsTableViewController *likedStringsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikedStringsVC"];
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
