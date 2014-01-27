//
//  StringFooterTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringFooterTableViewCell.h"
#import "StringrFooterView.h"
#import "StringrPathImageView.h"


@interface StringFooterTableViewCell ()

@property (strong, nonatomic) StringrFooterView *contentFooterView;

@property (strong, nonatomic) StringrPathImageView *profileImageView;

@property (strong, nonatomic) UILabel *profileNameLabel;

@property (strong, nonatomic) UILabel *uploadDateLabel;

@property (strong, nonatomic) UILabel *commentsTextLabel;
@property (strong, nonatomic) UIImageView *commentsImageView;
@property (strong, nonatomic) UIButton *commentsButton;

@property (strong, nonatomic) UILabel *likesTextLabel;
@property (strong, nonatomic) UIImageView *likesImageView;
@property (strong, nonatomic) UIButton *likesButton;

@end

@implementation StringFooterTableViewCell

#pragma mark - Lifecycle

static float const contentViewWidth = 320.0;
static float const contentViewHeight = 41.5;
static float const contentFooterViewWidthPercentage = .93;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
        
        float footerXLocation = (contentViewWidth - (contentViewWidth * contentFooterViewWidthPercentage)) / 2;
        CGRect footerRect = CGRectMake(footerXLocation, 0, contentViewWidth * contentFooterViewWidthPercentage, contentViewHeight);
        
        self.contentFooterView = [[StringrFooterView alloc] initWithFrame:footerRect withFullWidthCell:NO];
        [self.contentView addSubview:self.contentFooterView];
    }
    
    return self;
}




#pragma mark - Custom Accessors

- (void)setStringUploaderProfileImage:(UIImage *)stringUploaderProfileImage
{
    _stringUploaderProfileImage = stringUploaderProfileImage;

    if (_stringUploaderProfileImage) {
        self.contentFooterView.profileImageView.image = _stringUploaderProfileImage;
    }
}

- (void)setStringUploaderName:(NSString *)stringUploaderName
{
    _stringUploaderName = stringUploaderName;
    self.contentFooterView.profileNameLabel.text = _stringUploaderName;
}

- (void)setStringUploadDate:(NSString *)stringUploadDate
{
    _stringUploadDate = stringUploadDate;
    self.contentFooterView.uploadDateLabel.text= _stringUploadDate;
}

- (void)setCommentButtonTitle:(NSString *)commentButtonTitle
{
    _commentButtonTitle = commentButtonTitle;
    self.contentFooterView.commentsTextLabel.text = _commentButtonTitle;
}

- (void)setLikeButtonTitle:(NSString *)likeButtonTitle
{
    _likeButtonTitle = likeButtonTitle;
    self.contentFooterView.likesTextLabel.text = _likeButtonTitle;
}



@end
