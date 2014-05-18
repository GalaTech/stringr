//
//  StringrPhotoTopDetailViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/24/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPhotoDetailTopViewController.h"


@interface StringrPhotoDetailTopViewController () <ParseImagePagerDataSource, ParseImagePagerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation StringrPhotoDetailTopViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)dealloc
{
    NSLog(@"dealloc photo detail top");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoRemovedFromPublicString:) name:kNSNotificationCenterRemovedPhotoFromPublicString object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterRemovedPhotoFromPublicString object:nil];
}




#pragma mark - Custom Acessors

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] initWithCapacity:[self.photosToLoad count]];
    }
    
    return _photos;
}




#pragma mark - Public

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    if (index > self.photos.count) {
        return nil;
    }
    
    UIImage *photo;
    
    if (self.photos) {
        NSDictionary *photoDictionary = [[NSDictionary alloc] init];
        
        for (photoDictionary in self.photos) {
            
            NSUInteger photoIndex = [[photoDictionary objectForKey:@"index"] unsignedIntegerValue];
            
            if (photoIndex == index) {
                photo = [photoDictionary objectForKey:@"photo"];
                return photo;
            }
        }
    }
    
    return photo;
}

- (void)savePhoto:(PFObject *)photo
{
    [self findAndSendNotificationToMentionsInPhoto:photo];
    [photo saveInBackground];
}




#pragma mark - Private

- (void)findAndSendNotificationToMentionsInPhoto:(PFObject *)photo
{
    // Extracts all of the @mentions from the title and description of the photo
    NSArray *titleMentions = [StringrUtility mentionsContainedWithinString:[photo objectForKey:kStringrPhotoCaptionKey]];
    NSArray *descriptionMentions = [StringrUtility mentionsContainedWithinString:[photo objectForKey:kStringrPhotoDescriptionKey]];
    
    NSMutableSet *combinedMentionsSet = [NSMutableSet setWithArray:titleMentions];
    [combinedMentionsSet addObjectsFromArray:descriptionMentions];
    
    NSArray *combinedMentionsArray = [combinedMentionsSet allObjects];
    
    // Finds all users whose username matches these mentions.
    PFQuery *mentionUsersQuery = [PFUser query];
    [mentionUsersQuery whereKey:kStringrUserUsernameKey containedIn:combinedMentionsArray];
    [mentionUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (!error) {
            // Finds any activities that might already exist for the mentioned usernames on this photo
            PFQuery *activityMentionQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
            [activityMentionQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeMention];
            [activityMentionQuery whereKey:kStringrActivityPhotoKey equalTo:photo];
            [activityMentionQuery whereKey:kStringrActivityToUserKey containedIn:users];
            [activityMentionQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
            [activityMentionQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
                if (!error) {
                    // delete any activities that already existed so that there will not be duplicates
                    for (PFObject *activity in activities) {
                        [activity deleteInBackground];
                    }
                    
                    // Create a new mention activity for all users who were mentioned in the photo
                    for (PFUser *user in users) {
                        if (![user.objectId isEqualToString:[PFUser currentUser].objectId]){
                            PFObject *mentionActivity = [PFObject objectWithClassName:kStringrActivityClassKey];
                            [mentionActivity setObject:kStringrActivityTypeMention forKey:kStringrActivityTypeKey];
                            [mentionActivity setObject:user forKey:kStringrActivityToUserKey];
                            [mentionActivity setObject:[PFUser currentUser] forKey:kStringrActivityFromUserKey];
                            [mentionActivity setObject:photo forKey:kStringrActivityPhotoKey];
                            
                            PFACL *mentionACL = [PFACL ACLWithUser:[PFUser currentUser]];
                            [mentionACL setPublicReadAccess:YES];
                            [mentionACL setPublicWriteAccess:YES];
                            [mentionActivity setACL:mentionACL];
                            
                            [mentionActivity saveInBackground];
                        }
                    }
                }
            }];
        }
    }];
}




#pragma mark - Action Handlers

- (void)photoRemovedFromPublicString:(NSNotification *)notification
{
    NSDictionary *notificationDictionary = [notification userInfo];
    PFObject *photo = [notificationDictionary objectForKey:@"photo"];
    
    if (photo) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - ParseImagePager DataSource

- (NSArray *)arrayWithPhotoPFObjects
{
    return self.photosToLoad;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFit;
}



#pragma mark - ParseImagePager Delegate

- (void)imagePager:(ParseImagePager *)imagePager didLoadImage:(UIImage *)image atIndex:(NSUInteger)index
{
    NSDictionary *photo = [[NSDictionary alloc] initWithObjectsAndKeys:image, @"photo", @(index), @"index", nil];
    [self.photos addObject:photo];
}

- (void)imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    if (index <= [self.photosToLoad count]) {
        if ([self.delegate respondsToSelector:@selector(photoViewer:didScrollToIndex:)]) {
            [self.delegate photoViewer:imagePager didScrollToIndex:index];
        }
    }
}

- (void)imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoViewer:didTapPhotoAtIndex:)]) {
        [self.delegate photoViewer:imagePager didTapPhotoAtIndex:index];
    }
}

/*
- (void)imagePager:(ParseImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"did scroll %d", index);
}

- (void)imagePager:(ParseImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"did tap %d", index);
}
*/


@end
