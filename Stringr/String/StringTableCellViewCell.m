//
//  StringTableCellViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/1/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringTableCellViewCell.h"
#import "StringCellView.h"
#import "StringrDetailViewController.h"

#import "GBPathImageView.h"

@interface StringTableCellViewCell ()

@property (strong, nonatomic) StringCellView *stringCollectionView;

@property (strong, nonatomic) GBPathImageView *detailTabProfileImage;
@property (strong, nonatomic) UILabel *detailTabNumberOfCommentsLabel;
@property (strong, nonatomic) UILabel *detailTabNumberOfLikesLabel;

@end


@implementation StringTableCellViewCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
         _stringCollectionView= [[NSBundle mainBundle] loadNibNamed:@"StringCellView" owner:self options:nil][0];
        _stringCollectionView.frame = self.bounds;
        [self.contentView addSubview:_stringCollectionView];
        
        
        //_detailTabView = [[NSBundle mainBundle] loadNibNamed:@"StringrStringDetailTab" owner:self options:nil][0];

        
        
        /*
#define kDetail_Tab_Center_Point _detailTabView.frame.size.width / 2
#define kDetail_Tab_Profile_Image_Size _detailTabView.frame.size.width * .9
        
        // Creates the detail tab view for String table view cells
        CGRect detailTabViewFrame = CGRectMake(0, 10, 30, 115);
        _detailTabView = [[UIView alloc] initWithFrame:detailTabViewFrame];
        [_detailTabView setBackgroundColor:[UIColor whiteColor]];
        [_detailTabView setAlpha:0.95];
    
        
        // Adds profile image to the detial tab view
        CGRect profileImageFrame = CGRectMake(kDetail_Tab_Center_Point - (kDetail_Tab_Profile_Image_Size / 2),
                                              4,
                                              kDetail_Tab_Profile_Image_Size,
                                              kDetail_Tab_Profile_Image_Size);
        
        _detailTabProfileImage = [[GBPathImageView alloc] initWithFrame:profileImageFrame
                                                                  image:[UIImage imageNamed:@"alonsoAvatar.jpg"]
                                                               pathType:GBPathImageViewTypeCircle
                                                              pathColor:[UIColor darkGrayColor]
                                                            borderColor:[UIColor whiteColor]
                                                              pathWidth:0.25];
        [_detailTabView addSubview:_detailTabProfileImage];
        
        
        // Adds comment icon to the detail tab view
        CGRect commentIconFrame = CGRectMake(7, 38, 17, 17);
        UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:commentIconFrame];
        [commentIcon setImage:[UIImage imageNamed:@"comment-bubble.png"]];
        [_detailTabView addSubview:commentIcon];
        
        
        // Adds the number of comments label to the detail view
        _detailTabNumberOfCommentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 50, 0, 13)];
        [_detailTabNumberOfCommentsLabel setText:@"42"];
        [_detailTabNumberOfCommentsLabel sizeToFit];
        [_detailTabNumberOfCommentsLabel setTextColor:[UIColor darkGrayColor]];
        [_detailTabNumberOfCommentsLabel setTextAlignment:NSTextAlignmentCenter];
        [_detailTabNumberOfCommentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
        [_detailTabNumberOfCommentsLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [_detailTabView addSubview:_detailTabNumberOfCommentsLabel];
        
        
        // Adds like icon to the detail tab view
        CGRect likeIconFrame = CGRectMake(7, 76, 17, 17);
        UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:likeIconFrame];
        [likeIcon setImage:[UIImage imageNamed:@"like-bubble.png"]];
        [_detailTabView addSubview:likeIcon];
        
        
        // Adds the number of likes label to the detail view
        _detailTabNumberOfLikesLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 90, 0, 13)];
        [_detailTabNumberOfLikesLabel setText:@"67"];
        [_detailTabNumberOfLikesLabel sizeToFit];
        [_detailTabNumberOfLikesLabel setTextColor:[UIColor darkGrayColor]];
        [_detailTabNumberOfLikesLabel setTextAlignment:NSTextAlignmentCenter];
        [_detailTabNumberOfLikesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
        [_detailTabNumberOfLikesLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [_detailTabView addSubview:_detailTabNumberOfLikesLabel];
        
        
        [self.contentView addSubview:_detailTabView];
         */
    }
    
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCollectionData:(NSArray *)collectionData
{
    [_stringCollectionView setCollectionData:collectionData];
}


@end
