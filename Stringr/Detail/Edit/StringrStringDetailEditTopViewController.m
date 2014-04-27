//
//  StringrStringDetailTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailEditTopViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrPhotoDetailEditTableViewController.h"
#import "StringViewReorderable.h"
#import "StringrNavigationController.h"

@interface StringrStringDetailEditTopViewController () <StringrPhotoDetailEditTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringViewReorderable *stringReorderableCollectionView;

@end

@implementation StringrStringDetailEditTopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    // commented out because I need to load an editable string view
    //[super viewDidLoad];
    
    _stringReorderableCollectionView = [[NSBundle mainBundle] loadNibNamed:@"StringLargeReorderableCollectionView" owner:self options:nil][0];
    _stringReorderableCollectionView.frame = self.stringView.bounds;
    [_stringReorderableCollectionView setDelegate:self];
    [_stringReorderableCollectionView setStringObject:self.stringToLoad];
    
    if (self.userSelectedPhoto) {
        [self addNewImageToString:self.userSelectedPhoto];
    }
    
    [self.stringView addSubview:_stringReorderableCollectionView];
    
    [self.view setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



#pragma mark - Public

- (void)addNewImageToString:(UIImage *)image
{
    // creates a local weak version of self so that I can use it inside of the block
    __weak typeof(self) weakSelf = self;
    
    [self.stringReorderableCollectionView addImageToString:image withBlock:^(BOOL succeeded, PFObject *photo, NSError *error) {
        if (succeeded) {
            StringrPhotoDetailViewController *editPhotoVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            [editPhotoVC setEditDetailsEnabled:YES];
            [editPhotoVC setStringOwner:weakSelf.stringToLoad];
            [editPhotoVC setSelectedPhotoIndex:0];
            [editPhotoVC setPhotosToLoad:@[photo]];
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:editPhotoVC];
            
            [weakSelf presentViewController:navVC animated:YES completion:nil];
        }
    }];
}

- (void)saveString
{
    [self.stringReorderableCollectionView saveAndPublishInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)cancelString
{
    [self.stringReorderableCollectionView cancelString];
}




#pragma mark - StringrStringDetailEditTableViewController Delegate

- (void)setStringTitle:(NSString *)title description:(NSString *)description andWriteAccess:(BOOL)canWrite
{
    [self setStringTitle:title];
    [self setStringDescription:description];
    [self setStringWriteAccess:canWrite];
}

- (void)setStringTitle:(NSString *)title
{
    NSLog(@"set string title");
}

- (void)setStringDescription:(NSString *)description
{
    NSLog(@"set description");
}

- (void)setStringWriteAccess:(BOOL)canWrite
{
    [self.stringReorderableCollectionView setStringWriteAccess:canWrite];
}

- (void)deleteString
{
    [self.stringReorderableCollectionView deleteString];
    // delete string and all photos inside here
}



#pragma mark - StringrPhotoDetailEditTableViewControllerDelegate

- (void)deletePhotoFromString:(PFObject *)photo
{
    [self.stringReorderableCollectionView removePhotoFromString:photo];
}



#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        PFObject *photo = [photos objectAtIndex:index];
        
        // makes sure that we aren't trying to move to the photo viewer with something that isn't a photo PFObject
        if (photo && [photo isKindOfClass:[PFObject class]]) {
            
            StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
            
            [photoDetailVC setEditDetailsEnabled:YES];
            [photoDetailVC setDelegateForPhotoController:self]; // allows for deletion
            
            // Sets the initial photo to the selected cell's PFObject photo data
            [photoDetailVC setPhotosToLoad:photos];
            [photoDetailVC setSelectedPhotoIndex:index];
            [photoDetailVC setStringOwner:string];
            
            StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:photoDetailVC];
            
            [self.navigationController presentViewController:navVC animated:YES completion:nil];
        }
    }
}

@end
