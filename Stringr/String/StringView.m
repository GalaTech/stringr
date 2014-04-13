//
//  StringCellView.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringView.h"
#import "StringCollectionViewCell.h"
#import "NHBalancedFlowLayout.h"
#import "StringCollectionView.h"
#import "UIImage+Decompression.h"

#import <QuartzCore/QuartzCore.h>

@interface StringView () <NHBalancedFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet StringCollectionView *stringCollectionView;
@property (weak, nonatomic) IBOutlet StringCollectionView *stringLargeCollectionView;

@property (strong, nonatomic) NSMutableArray *collectionData;


@end
@implementation StringView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    // Register the colleciton cell for both large and normal string sizes
    [_stringCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];
    // Large is only utilized on the detail string pages
    [_stringLargeCollectionView registerNib:[UINib nibWithNibName:@"StringCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StringCollectionViewCell"];    
}




#pragma mark - Custom Accessors

- (void)setCollectionData:(NSMutableArray *)collectionData {
    _collectionData = collectionData;
}

- (void)setStringObject:(PFObject *)string
{
    if (string) {
        _stringToLoad = string;
        
        // queries parse after a string object has been set to load
        [self queryPhotosFromString];
    }
}

- (NSMutableArray *)collectionViewPhotos
{
    if (!_collectionViewPhotos) {
        _collectionViewPhotos = [[NSMutableArray alloc] init];
    }
    
    return _collectionViewPhotos;
}


#pragma mark - Parse

- (void)queryPhotosFromString
{    
    if (self.stringToLoad) {
        PFQuery *stringPhotoQuery = [PFQuery queryWithClassName:kStringrPhotoClassKey];
        [stringPhotoQuery whereKey:kStringrPhotoStringKey equalTo:self.stringToLoad];
        [stringPhotoQuery orderByAscending:@"photoOrder"]; // photoOrder: each photo has a number associated with where it falls into the string
        
        [stringPhotoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if (!error) {
                self.collectionViewPhotos = [[NSMutableArray alloc] initWithArray:photos];
                
                if (self.stringCollectionView) {
                    [self.stringCollectionView reloadData];
                } else if (self.stringLargeCollectionView) {
                    [self.stringLargeCollectionView reloadData];
                }
            }
        }];
    }
}

// liked photos
- (void)queryPhotosFromQuery:(PFQuery *)query
{
    if (query) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.collectionViewPhotos = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < objects.count; i++) {
                PFObject *activityObject = [objects objectAtIndex:i];
                PFObject *photo = [activityObject objectForKey:kStringrActivityPhotoKey];
                
                [photo fetchIfNeededInBackgroundWithBlock:^(PFObject *photoObject, NSError *error) {
                    [self.collectionViewPhotos addObject:photoObject];
                }];
                
                if (i == objects.count - 1) {
                    if (self.stringCollectionView) {
                        [self.stringCollectionView reloadData];
                    } else if (self.stringLargeCollectionView) {
                        [self.stringLargeCollectionView reloadData];
                    }
                }
            }
        }];
    }
}




#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StringCollectionViewCell *stringCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StringCollectionViewCell" forIndexPath:indexPath];
    
    // used for when a user taps on a photo in the string
    //stringCell.tag = indexPath.item;
    
    [stringCell.loadingImageIndicator setHidden:NO];
    [stringCell.loadingImageIndicator startAnimating];
    
    id photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    if ([photo isKindOfClass:[PFObject class]]) {
        PFObject *photoObject = (PFObject *)photo;
        
        PFFile *imageFile = [photoObject objectForKey:kStringrPhotoPictureKey];
        [stringCell.cellImage setFile:imageFile];
        [stringCell.cellImage loadInBackground:^(UIImage *image, NSError *error) {
            [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
            [stringCell.loadingImageIndicator stopAnimating];
            [stringCell.loadingImageIndicator setHidden:YES];
        }];
    } else if ([photo isKindOfClass:[UIImage class]]) {
        [stringCell.cellImage setImage:photo];
        [stringCell.cellImage setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    
    return stringCell;
}




#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Sends information to delegate for what cell was tapped. This allows for simple access to push details about the selected cells data.
    [self.delegate collectionView:collectionView tappedPhotoAtIndex:indexPath.row inPhotos:self.collectionViewPhotos fromString:self.stringToLoad];
}




#pragma mark - StringCollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *photo = [self.collectionViewPhotos objectAtIndex:indexPath.item];
    
    NSNumber *width = [photo objectForKey:kStringrPhotoPictureWidth];
    NSNumber *height = [photo objectForKey:kStringrPhotoPictureHeight];
    
    return CGSizeMake([width floatValue], [height floatValue]);
}



@end
