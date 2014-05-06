//
//  StringrStringTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTopViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringrNavigationController.h"
#import "StringrFooterView.h"

@interface StringrStringDetailTopViewController ()

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringView *stringCollectionView;

@end

@implementation StringrStringDetailTopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _stringCollectionView = [[NSBundle mainBundle] loadNibNamed:@"StringLargeCollectionView" owner:self options:nil][0];
    _stringCollectionView.frame = self.stringView.bounds;
    [_stringCollectionView setStringObject:self.stringToLoad];
    [_stringCollectionView setDelegate:self];
    
    //[_stringCollectionView setCollectionData:[self.stringPhotoData mutableCopy]];
    [self.stringView addSubview:_stringCollectionView];
    
    self.view.backgroundColor = [StringrConstants kStringCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadString) name:kNSNotificationCenterDeletePhotoFromStringKey object:nil];
}
 
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterDeletePhotoFromStringKey object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)addImageToPublicString:(UIImage *)image
{
    // creates a local weak version of self so that I can use it inside of the block
    __weak typeof(self) weakSelf = self;

    [self.stringCollectionView addImageToString:image withBlock:^(BOOL succeeded, PFObject *photo, NSError *error) {
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




#pragma mark - Actions

- (void)reloadString
{
    [self.stringCollectionView reloadString];
}


#pragma mark - StringView Delegate

- (void)collectionView:(UICollectionView *)collectionView tappedPhotoAtIndex:(NSInteger)index inPhotos:(NSArray *)photos fromString:(PFObject *)string
{
    if (photos)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardPhotoDetailID];
        [photoDetailVC setStringOwner:string];
        
        // Sets the initial photo to the selected cell's PFObject photo data
        [photoDetailVC setPhotosToLoad:photos];
        [photoDetailVC setSelectedPhotoIndex:index];
        [photoDetailVC setEditDetailsEnabled:NO];

        [photoDetailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}

@end
