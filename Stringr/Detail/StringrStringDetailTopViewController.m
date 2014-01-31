//
//  StringrStringTopEditViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrStringDetailTopViewController.h"
#import "StringrPhotoDetailViewController.h"
#import "StringView.h"
#import "StringrFooterView.h"

@interface StringrStringDetailTopViewController ()

@property (weak, nonatomic) IBOutlet UIView *stringView;
@property (strong, nonatomic) StringView *stringCollectionView;

@end

@implementation StringrStringDetailTopViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _stringCollectionView = [[NSBundle mainBundle] loadNibNamed:@"StringLargeCollectionView" owner:self options:nil][0];
    _stringCollectionView.frame = self.stringView.bounds;
    [_stringCollectionView setCollectionData:self.stringPhotoData];
    [self.stringView addSubview:_stringCollectionView];
    
    
    
    self.view.backgroundColor = [StringrConstants kStringCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
}
 
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}
 




#pragma mark - Custom Accessors

static int const NUMBER_OF_IMAGES = 24;

- (NSArray *)stringPhotoData
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
        NSString *imageName = [NSString stringWithFormat:@"photo-%02d.jpg", i];
        
        NSDictionary *photo = @{@"title": @"Article A1", @"image": imageName};
        
        [images addObject:photo];
    }
    _stringPhotoData = [images copy];
    
    return _stringPhotoData;
}



 
 #pragma mark - NSNotificationCenter Actions
 
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];

    if (cellData)
    {
        StringrPhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"photoDetailVC"];
     
        [photoDetailVC setDetailsEditable:NO];
        // Sets the initial photo to the selected cell
        [photoDetailVC setCurrentImage:[UIImage imageNamed:[cellData objectForKey:@"image"]]];
     
        [photoDetailVC setHidesBottomBarWhenPushed:YES];
     
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
}





@end
