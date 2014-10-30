//
//  StringrPushNotificationsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 4/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPushNotificationsTableViewController.h"
#import "UIColor+StringrColors.h"

@interface StringrPushNotificationsTableViewController ()

@property (strong, nonatomic) UISwitch *pushNotificationsEnabledSwitch;

@end

@implementation StringrPushNotificationsTableViewController

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Push Notifications";
        self.tableView.backgroundColor = [UIColor stringTableViewBackgroundColor];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_identifier"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)setupSwitchForCell:(UITableViewCell *)cell
{
    float width = CGRectGetWidth(cell.frame);
    float height = CGRectGetHeight(cell.frame);
    
    self.pushNotificationsEnabledSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 70, height / 2 - 15, 51, 31)];
    [self.pushNotificationsEnabledSwitch setEnabled:YES];
    [self.pushNotificationsEnabledSwitch addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kNSUserDefaultsPushNotificationsEnabledKey]) {
        BOOL switchEnabled = [defaults boolForKey:kNSUserDefaultsPushNotificationsEnabledKey];
        self.pushNotificationsEnabledSwitch.on = switchEnabled;
    } else {
        self.pushNotificationsEnabledSwitch.on = YES;
    }
    
    [cell addSubview:self.pushNotificationsEnabledSwitch];
}

- (void)toggledSwitch:(UISwitch *)switchControl
{
    if (switchControl.on) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSUserDefaultsPushNotificationsEnabledKey];;
        [[NSUserDefaults standardUserDefaults] synchronize];
        // see if we have a private channel key already associated with the current user
        // if we do set the current installation's channel to that of the current user.
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey];
        if (privateChannelName && privateChannelName.length > 0) {
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kStringrInstallationPrivateChannelsKey];
            [[PFInstallation currentInstallation] saveEventually];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNSUserDefaultsPushNotificationsEnabledKey];;
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[PFInstallation currentInstallation] removeObjectForKey:kStringrInstallationUserKey];
        [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kStringrUserPrivateChannelKey] forKey:kStringrInstallationPrivateChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Enable Push Notifications"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [self setupSwitchForCell:cell];
        }
        
        UIFont *cellTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        [cell.textLabel setFont:cellTextFont];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}



#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
