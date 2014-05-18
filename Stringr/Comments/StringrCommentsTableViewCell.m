//
//  StringrCommentsTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 1/31/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrCommentsTableViewCell.h"
#import "StringrProfileViewController.h"
#import "StringrPathImageView.h"

@interface StringrCommentsTableViewCell ()

@property (nonatomic) NSUInteger rowNumberForCommentCell;
@property (strong, nonatomic) PFUser *commentUser;

@property (weak, nonatomic) IBOutlet StringrPathImageView *commentsProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *commentsProfileDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *commentsUploadDateTime;
@property (weak, nonatomic) IBOutlet UILabel *commentsTextComment;

@end

@implementation StringrCommentsTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [_commentsProfileImage setImageToCirclePath];
    [_commentsProfileImage setPathColor:[UIColor darkGrayColor]];
    [_commentsProfileImage setPathWidth:1.0];
    
    

    //[self addSubview:[self commentSeperatorView]];
    [self addSubview:[self profileImageButton]];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        StringrPathImageView *profileImage = [[StringrPathImageView alloc] initWithFrame:CGRectMake(5, 5, 38, 38) image:[UIImage imageNamed:@"Stringr Image"] pathColor:[UIColor darkGrayColor] pathWidth:1.0];
        
        UIButton *profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 38, 38)];
        [profileImageButton addTarget:self action:@selector(pushToUserProfile) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:profileImage];
        [self.contentView addSubview:profileImageButton];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Custom Accessors

// Also Public
- (void)setObjectForCommentCell:(PFObject *)object
{
    [self setupCommentCellWithObject:object];
}

- (void)setRowForCommentCell:(NSUInteger)row
{
    self.rowNumberForCommentCell = row;
}


#pragma mark - Action Handlers

- (void)pushToUserProfile
{
    if ([self.delegate respondsToSelector:@selector(tappedCommentorUserProfileImage:)]) {
        [self.delegate tappedCommentorUserProfileImage:self.commentUser];
    }
}




#pragma mark - Private

- (void)setupCommentCellWithObject:(PFObject *)object
{
    _commentUser = [object objectForKey:kStringrActivityFromUserKey];
    
    NSString *commentorUsername = [StringrUtility usernameFormattedWithMentionSymbol:[_commentUser objectForKey:kStringrUserUsernameCaseSensitive]];
    [self.commentsProfileDisplayName setText:commentorUsername];
    
    [self.commentsTextComment setText:[object objectForKey:kStringrActivityContentKey]];
    [self.commentsUploadDateTime setText:[StringrUtility timeAgoFromDate:object.createdAt]];
    
    PFFile *profileImageFile = [_commentUser objectForKey:kStringrUserProfilePictureThumbnailKey];
    [self.commentsProfileImage setFile:profileImageFile];
    // set the tag to the row so that we can access the correct user when tapping on a profile image
    [self.commentsProfileImage loadInBackgroundWithIndicator];
    
}

- (UIView *)commentSeperatorView
{
    UIView *commentCellSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 3, CGRectGetWidth(self.frame), 3)];
    [commentCellSeperator setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    
    UIColor *countourLineColor = [UIColor colorWithWhite:0.78 alpha:1.0];
    UIColor *lightContourLineColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    UIImageView *topContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    [topContourLine setBackgroundColor:countourLineColor];
    
    UIImageView *bottomContourLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, CGRectGetWidth(self.frame), 1)];
    [bottomContourLine setBackgroundColor:lightContourLineColor];
    
    [commentCellSeperator addSubview:topContourLine];
    [commentCellSeperator addSubview:bottomContourLine];
    
    return commentCellSeperator;
}

- (UIButton *)profileImageButton
{
    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:_commentsProfileImage.frame];
    [profileImageButton addTarget:self action:@selector(pushToUserProfile) forControlEvents:UIControlEventTouchUpInside];
    
    return profileImageButton;
}


@end
