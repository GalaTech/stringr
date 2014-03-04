//
//  TestViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/22/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestViewController.h"
#import "StringCollectionView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"
#import "StringrPathImageView.h"

@interface TestViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NHBalancedFlowLayoutDelegate>

@property (strong, nonatomic) NSArray *collectionViewImages;

@property (weak, nonatomic) IBOutlet StringrPathImageView *testProfileImage;
@property (weak, nonatomic) IBOutlet StringCollectionView *imagesCollectionView;

@end

@implementation TestViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryStringFromParse];
    
    
    
    [self.testProfileImage setImage:[UIImage imageNamed:@"Stringr Image"]];
    [self.testProfileImage setFile:[[PFUser currentUser] objectForKey:kStringrUserProfilePictureKey]];
    [self.testProfileImage loadInBackground];
    
    [self.testProfileImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.testProfileImage setImageToCirclePath];
    [self.testProfileImage setPathColor:[UIColor darkGrayColor]];
    [self.testProfileImage setPathWidth:1.0];
    

    
    /*
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(170, 170);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
     
    StringCollectionView *collectionView = [[StringCollectionView alloc] initWithFrame:CGRectMake(0, 50, 320, 170) collectionViewLayout:flowLayout];
    
    [self.view addSubview:collectionView];
    self.imagesCollectionView = collectionView;
    
    
    
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
	// Do any additional setup after loading the view.
     */
    
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)queryStringFromParse
{
    /*
    PFQuery *photoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
    
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.collectionViewImages = [[NSArray alloc] initWithArray:objects];
            [self.imagesCollectionView reloadData];
        }
    }];
     */
    
    
    PFQuery *stringQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    
    [stringQuery getObjectInBackgroundWithId:@"bW7gX8Zqni" block:^(PFObject *string, NSError *error) {
        
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery orderByAscending:@"createdAt"];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:string];
        
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            self.collectionViewImages = [[NSArray alloc] initWithArray:photos];
            [self.imagesCollectionView reloadData];
        }];
        
    }];
    
    
    
    
    
    /*
    PFQuery *stringQuery = [PFQuery queryWithClassName:kStringrStringClassKey];
    
    [stringQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *firstString = [objects lastObject];

            self.collectionViewImages = [[NSArray alloc] initWithArray:[firstString objectForKey:kStringrStringPhotosKey]];
            
            [self.imagesCollectionView reloadData];
        }
    }];
     */
}





#pragma mark - UICollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StringCollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[StringCollectionViewCell class]]) {
        StringCollectionViewCell *stringImageCell = (StringCollectionViewCell *)cell;
        [stringImageCell.loadingImageIndicator setHidden:NO];
        [stringImageCell.loadingImageIndicator startAnimating];
        //[stringImageCell.cellImage setImage:[UIImage imageNamed:@"Stringr Image"]];
        
        PFObject *photoObject = [self.collectionViewImages objectAtIndex:indexPath.item];
        
        PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
        
        [stringImageCell.cellImage setFile:imageFile];
        
        [stringImageCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
            [stringImageCell.loadingImageIndicator stopAnimating];
            [stringImageCell.loadingImageIndicator setHidden:YES];
        }];
        
        
        /*
        [photoObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            PFFile *imageFile = [object objectForKey:kStringrPhotoPictureKey];
            
            [stringImageCell.cellImage setFile:imageFile];
            
            [stringImageCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
                [stringImageCell.loadingImageIndicator stopAnimating];
                [stringImageCell.loadingImageIndicator setHidden:YES];
            }];
            
        }];
         */
        
    }
    
    
    
    
    /*
    if (indexPath.item % 2 == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        UIImage *cellImage = [UIImage imageNamed:@"alonsoAvatar.jpg"];
        [stringCell.cellImage setImage:cellImage];
        
        return stringCell;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
        StringCollectionViewCell *stringCell = (StringCollectionViewCell *)cell;
        UIImage *cellImage = [UIImage imageNamed:@"photo-01.jpg"];
        [stringCell.cellImage setImage:cellImage];
        
        return stringCell;
    }
     */
    
    return cell;
}


#pragma mark - NHBalancedFlowLayout Delegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize imageSize = CGSizeMake(157, 157);
    
    
    
    
    return imageSize;
}



@end
