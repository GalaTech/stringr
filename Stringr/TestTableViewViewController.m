//
//  TestTableViewViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewViewController.h"
#import "TestTableViewCell.h"
#import "UIImage+Resize.h"

@interface TestTableViewViewController ()

@end

@implementation TestTableViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = kStringrPhotoClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 4;
    }
    
    return self;
}

static int const PHOTO_HEIGHT = 157;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    UIImage *photoToUpload = [UIImage imageNamed:@"photo-06.jpg"];
    
    float scale = PHOTO_HEIGHT / photoToUpload.size.height;
    float width = photoToUpload.size.width * scale;
    
    CGSize photoToUploadSize = CGSizeMake(width, PHOTO_HEIGHT);
    
    // In this case there would also be another photo that would be relatively full size.
    // This is essentially just the thumbnail
    UIImage *resizedPhotoImage = [photoToUpload resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:photoToUploadSize interpolationQuality:kCGInterpolationHigh];
    
    NSData *photoData = UIImageJPEGRepresentation(resizedPhotoImage, 0.8f);
    
    PFFile *photo = [PFFile fileWithName:@"photo-06.jpg" data:photoData];
    
    PFObject *photoObject = [PFObject objectWithClassName:kStringrPhotoClassKey];
    
    photoObject[kStringrPhotoPictureKey] = photo;
    photoObject[kStringrPhotoCaptionKey] = @"The Sixth Photo!";
    [photoObject saveInBackground];
    */
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:kStringrPhotoClassKey];
    
    PFObject *photoObject = [query getFirstObject];
    
    photoObject[kStringrPhotoCaptionKey] = @"The most recently updated photo.";
    [photoObject saveInBackground];
    */

    /*
    PFQuery *query = [PFQuery queryWithClassName:kStringrPhotoClassKey];
    [query getObjectInBackgroundWithId:@"9dl0uotyDq" block:^(PFObject *photo, NSError *error) {
        
        NSDate *date = photo.createdAt;
        
        NSString *timeAgo = [StringrUtility timeAgoFromDate:date];
        
        NSLog(@"%@", timeAgo);
    }];
    
    
    PFObject *photoObject = [PFObject objectWithClassName:kStringrPhotoClassKey];
    photoObject[kStringrPhotoCaptionKey] = @"This is a test!";
    [photoObject saveInBackground];
    
    
    
    NSDate *date = [NSDate date];
    
    double delayInSeconds = 180.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *timeSinceDate = [StringrUtility timeAgoFromDate:date];
        
        NSLog(@"%@", timeSinceDate);
    });
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:kStringrPhotoClassKey];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}


#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}
 */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellIdentifier = @"Cell";
    
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    //cell.textLabel.text = object[kStringrUserDisplayNameKey];
    //cell.detailTextLabel.text = object[kStringrUserLocationKey];
    
    /*
    [cell.nameLabel setText:object[kStringrUserDisplayNameKey]];
    [cell.subTextLabel setText:object[kStringrUserLocationKey]];
    
    PFFile *image = object[kStringrUserProfilePictureKey];
    [cell.profileImage setImage:[UIImage imageNamed:@"Stringr Image"]];
    [cell.profileImage setFile:image];
    [cell.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    [cell.profileImage loadInBackground];
    */
    
    PFFile *photo = object[kStringrPhotoPictureKey];
    [cell.profileImage setImage:[UIImage imageNamed:@"Stringr Image"]];
    [cell.profileImage setFile:photo];
    [cell.profileImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.profileImage loadInBackground];
    
    [cell.nameLabel setText:object[kStringrPhotoCaptionKey]];
    
    NSDate *date = object.createdAt;
    
    NSString *uploadedTime = [StringrUtility timeAgoFromDate:date];

    [cell.subTextLabel setText:[NSString stringWithFormat:@"Uploaded %@", uploadedTime]];
    
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
    [cell.textLabel setText:[[PFUser currentUser] objectForKey:kStringrUserDisplayNameKey]];
    
    PFFile *image = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *profileImage = [UIImage imageWithData:data];
            [cell.imageView setImage:profileImage];
        }
    }];
    
    
    
    // Configure the cell...
    
    return cell;
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
