//
//  StringrStringDetailTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/30/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailEditTopViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringViewReorderable.h"
#import "StringrNavigationController.h"

@interface StringrStringDetailEditTopViewController ()

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
    /*
    if (self.userSelectedPhoto) {
        NSMutableArray *images = [[NSMutableArray alloc] initWithArray:self.stringPhotoData];
        UIImage *imageCopy = [self.userSelectedPhoto copy];
        NSDictionary *image = @{@"title" : @"Image", @"image" : imageCopy};
        [images addObject:image];
        self.stringPhotoData = [images copy];
    }
    
    [_stringReorderableCollectionView setCollectionData:[self.stringPhotoData mutableCopy]];
     */
    
    [_stringReorderableCollectionView setStringObject:self.stringToLoad];
    // sets self to subclass delegate for passing object information upon successful load completion
    [_stringReorderableCollectionView setSubclassDelegate:_stringReorderableCollectionView];
    
    [self.stringView addSubview:_stringReorderableCollectionView];
    
    [self.view setBackgroundColor:[StringrConstants kStringCollectionViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:kNSNotificationCenterSelectedStringItemKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePhotoFromString:) name:kNSNotificationCenterDeletePhotoFromStringKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterSelectedStringItemKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationCenterDeletePhotoFromStringKey object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Custom Accessors

/*
static int const NUMBER_OF_IMAGES = 24;

- (NSArray *)stringPhotoData
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
        NSString *imageName = [NSString stringWithFormat:@"photo-%02d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        NSDictionary *photo = @{@"title": @"Article A1", @"image": image};
        
        [images addObject:photo];
    }
    
 
    if (_userSelectedPhoto) {
        [images addObject:_userSelectedPhoto];
    }
 
    
    self.stringPhotoData = [images copy];
    
    return [images copy];
}


- (void)setUserSelectedPhoto:(UIImage *)userSelectedPhoto
{
    _userSelectedPhoto = userSelectedPhoto;
    NSMutableArray *images = [[NSMutableArray alloc] initWithArray:self.stringPhotoData];
    
    NSDictionary *image = @{@"title" : @"Image", @"image" : _userSelectedPhoto};
    [images addObject:image];
    self.stringPhotoData = [images copy];
    
    [_stringReorderableCollectionView setCollectionData:images];
}
*/





#pragma mark - NSNotificationCenter Actions

- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    
    if (cellData)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
        
        [photoDetailVC setDetailsEditable:YES];
        // Sets the initial photo to the selected cell
        [photoDetailVC setCurrentImage:[cellData objectForKey:@"image"]];
        StringrNavigationController *navVC = [[StringrNavigationController alloc] initWithRootViewController:photoDetailVC];
        
        [self presentViewController:navVC animated:YES completion:nil];
        //[self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}




#pragma mark - StringrStringDetailEditViewController Delegate

- (void)addNewImageToString:(UIImage *)image
{
    NSLog(@"made it");
    
    NSDictionary *photo = @{@"image" : image};
    
    [self.stringReorderableCollectionView addPhotoToString:photo];
    // create public method to insert new image into collection view
}

- (void)deletePhotoFromString:(NSNotification *)notification
{
    NSLog(@"Made it to delete");
    NSDictionary *photo = [notification object];
    
    [self.stringReorderableCollectionView removePhotoFromString:photo];
}

@end
