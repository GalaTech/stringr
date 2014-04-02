//
//  TestTableViewViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewViewController.h"
#import "StringTableViewCell.h"
#import "TestTableViewCell.h"
#import "UIImage+Resize.h"

@interface TestTableViewViewController ()

@end

@implementation TestTableViewViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = kStringrStringClassKey;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 2;
    }
    
    return self;
}

//static int const PHOTO_HEIGHT = 157;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[StringTableViewCell class] forCellReuseIdentifier:@"StringTableViewCell"];

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    
    // Hides the load more cell if there are no more objects
    if (self.objects == 0) {
        self.paginationEnabled = NO;
    } else {
        self.paginationEnabled = YES;
    }
}

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}



- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    PFTableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
    [loadMoreCell setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    return loadMoreCell;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.objects count];
}
 
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}
 
/*
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    } else {
        return nil;
    }
//    
//    if (indexPath.row % 2 != 0) {
//        return nil;
//    } else {
//        return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
//    }
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    //static NSString *cellIdentifier = @"Cell";
    
    if (indexPath.row == 0) {
        StringTableViewCell *stringCell = [tableView dequeueReusableCellWithIdentifier:@"StringTableViewCell"];
        [stringCell setStringObject:object];
        
        return stringCell;
    }
    /*
    else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"Cell";
        TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        [cell.nameLabel setText:object[kStringrStringTitleKey]];
        [cell.subTextLabel setText:object[kStringrStringDescriptionKey]];
        
        return cell;
    } 
     */
     else {
        return nil;
    }
    
    
    /*
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell.nameLabel setText:object[kStringrStringTitleKey]];
    [cell.subTextLabel setText:object[kStringrStringDescriptionKey]];
    */
     
    /*
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    PFFile *photo = object[kStringrPhotoPictureKey];
    [cell.profileImage setImage:[UIImage imageNamed:@"Stringr Image"]];
    [cell.profileImage setFile:photo];
    [cell.profileImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.profileImage loadInBackground];
    
    [cell.nameLabel setText:object[kStringrPhotoCaptionKey]];
    
    NSDate *date = object.createdAt;
    
    NSString *uploadedTime = [StringrUtility timeAgoFromDate:date];

    [cell.subTextLabel setText:[NSString stringWithFormat:@"Uploaded %@", uploadedTime]];
    */
    
    //return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.objects.count) {
        return 40.0f;
    }
    
    return 157.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


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
