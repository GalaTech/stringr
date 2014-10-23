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
#import "STTweetLabel.h"
#import "UIColor+StringrColors.h"

@interface StringrCommentsTableViewCell ()

@property (weak, nonatomic) IBOutlet StringrPathImageView *commentsProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *commentsProfileDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *commentsUploadDateTime;
@property (weak, nonatomic) IBOutlet STTweetLabel *commentsTextComment;

@property (strong, nonatomic) PFUser *commentUser;
@property (strong, nonatomic) PFObject *comment;
@property (nonatomic) NSUInteger rowNumberForCommentCell;

@end

@implementation StringrCommentsTableViewCell

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

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



//*********************************************************************************/
#pragma mark - Custom Accessors
//*********************************************************************************/

// Also Public
- (void)setObjectForCommentCell:(PFObject *)object
{
    [self setupCommentCellWithObject:object];
}

- (void)setRowForCommentCell:(NSUInteger)row
{
    self.rowNumberForCommentCell = row;
}



//*********************************************************************************/
#pragma mark - Action Handlers
//*********************************************************************************/

- (void)pushToUserProfile
{
    if ([self.delegate respondsToSelector:@selector(tappedCommentorUserProfileImage:)]) {
        [self.delegate tappedCommentorUserProfileImage:self.commentUser];
    }
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (void)setupCommentCellWithObject:(PFObject *)object
{
    self.comment = object;
    self.commentUser = [object objectForKey:kStringrActivityFromUserKey];
    
    NSString *commentorUsername = [StringrUtility usernameFormattedWithMentionSymbol:[_commentUser objectForKey:kStringrUserUsernameCaseSensitive]];
    [self.commentsProfileDisplayName setText:commentorUsername];
    
    [self.commentsUploadDateTime setText:[StringrUtility timeAgoFromDate:object.createdAt]];
    [self setupCommentTextWithText:[object objectForKey:kStringrActivityContentKey]];
    
    PFFile *profileImageFile = [_commentUser objectForKey:kStringrUserProfilePictureThumbnailKey];
    [self.commentsProfileImage setFile:profileImageFile];
    // set the tag to the row so that we can access the correct user when tapping on a profile image
    [self.commentsProfileImage loadInBackgroundWithIndicator];
}

- (void)setupCommentTextWithText:(NSString *)commentText
{
    [self.commentsTextComment setText:commentText];
    [self.commentsTextComment setNumberOfLines:200];
    
    NSMutableParagraphStyle *commentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [commentParagraphStyle setAlignment:NSTextAlignmentLeft];
    [commentParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
//    [commentParagraphStyle setParagraphSpacing:40.0f];
    
    UIColor *commentColor = [UIColor darkGrayColor];
    UIFont *commentFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    
    NSDictionary *commentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:commentColor, NSForegroundColorAttributeName, commentFont, NSFontAttributeName, commentParagraphStyle, NSParagraphStyleAttributeName, nil];
    [self.commentsTextComment setAttributes:commentAttributes];
    
    NSDictionary *handleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHandleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *hashtagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHashtagColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *httpAttributes = [NSDictionary dictionaryWithObjectsAndKeys:commentColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    
    [self.commentsTextComment setAttributes:handleAttributes hotWord:STTweetHandle];
    [self.commentsTextComment setAttributes:hashtagAttributes hotWord:STTweetHashtag];
    [self.commentsTextComment setAttributes:httpAttributes hotWord:STTweetLink];
    
    [self.commentsTextComment setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        if (hotWord == STTweetHandle) {
            NSString *username = [[string stringByReplacingOccurrencesOfString:@"@" withString:@""] lowercaseString];
            
            if ([self.delegate respondsToSelector:@selector(tableViewCell:tappedUserHandleWithName:)]) {
                [self.delegate tableViewCell:self tappedUserHandleWithName:username];
            }
        } else if (hotWord == STTweetHashtag) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:tappedHashtagWithText:)]) {
                [self.delegate tableViewCell:self tappedHashtagWithText:string];
            }
        }
    }];
}

- (UIView *)commentSeperatorView
{
    UIView *commentCellSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 3, CGRectGetWidth(self.frame), 3)];
    [commentCellSeperator setBackgroundColor:[UIColor stringrLightGrayColor]];
    
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
