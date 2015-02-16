//
//  StringTableViewHeader.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringTableViewHeader.h"
#import "StringrPathImageView.h"
#import "UIFont+StringrFonts.h"
#import "UIColor+StringrColors.h"
#import "PFUser+StringrAdditions.h"
#import "NSDate+StringrAdditions.h"
#import "NSString+StringrAdditions.h"

@interface StringTableViewHeader ()

@property (strong, nonatomic, readwrite) StringrString *string;

@property (weak, nonatomic) IBOutlet StringrPathImageView *stringProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *stringProfileUploader;
@property (weak, nonatomic) IBOutlet UILabel *stringUploadDate;
@property (weak, nonatomic) IBOutlet UIImageView *stringPrivacySettings;
@property (weak, nonatomic) IBOutlet UIButton *viewStringPhotosButton;

@end

@implementation StringTableViewHeader

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.93];
        self.backgroundView = view;
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupAppearance];
}


- (void)setFrame:(CGRect)frame
{
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}


- (void)prepareForReuse
{
    self.stringProfileImage.image = nil;
    self.stringProfileUploader.text = nil;
    self.stringUploadDate.text = nil;
    self.stringPrivacySettings.image = nil;
}


#pragma mark - Public

- (void)configureHeaderWithString:(StringrString *)string
{
    self.string = string;
    
    PFUser *user = self.string.uploader;
    
    if (!user.isDataAvailable) {
        [user fetchUserIfNeededInBackgroundWithBlock:^(PFUser *user, NSError *error) {
            [self configureProfileImageViewWithUser:user];
            [self configureProfileUploaderLabelWithUser:user];
            [self configureUploadDateLabel];
        }];
    }
    else {
        [self configureProfileImageViewWithUser:user];
        [self configureProfileUploaderLabelWithUser:user];
        [self configureUploadDateLabel];
    }
    
    [self configurePrivacyButton];
}


#pragma mark - Private

- (void)setupAppearance
{
    [self.stringProfileImage setupImageWithDefaultConfiguration];
    [self.stringProfileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    self.stringProfileUploader.font = [UIFont stringrHeaderPrimaryLabelFont];
    self.stringProfileUploader.textColor = [UIColor stringrPrimaryLabelColor];
    self.stringProfileUploader.alpha = 0.0f;
    
    self.stringUploadDate.font = [UIFont stringrHeaderSecondaryLabelFont];
    self.stringUploadDate.textColor = [UIColor stringrSecondaryLabelColor];
    self.stringUploadDate.alpha = 0.0f;
}

- (void)configureProfileImageViewWithUser:(PFUser *)user
{
    [self.stringProfileImage setFile:user[kStringrUserProfilePictureThumbnailKey]];
    [self.stringProfileImage loadInBackgroundWithIndicator];
    
    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:self.stringProfileImage.frame];
    [profileImageButton addTarget:self action:@selector(profileImageTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:profileImageButton];
}


- (void)configureProfileUploaderLabelWithUser:(PFUser *)user
{
    NSString *formattedUsername = [NSString stringWithUsernameFormat:user[kStringrUserUsernameCaseSensitive]];
    
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.stringProfileUploader.text = formattedUsername;
                         self.stringProfileUploader.alpha = 1.0f;
    } completion:nil];
}


- (void)configureUploadDateLabel
{
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.string) {
                             NSString *uploadTime = [self.string.updatedAt timeAgoFromDate];
                             [self.stringUploadDate setText:uploadTime];
                         } else {
                             [self.stringUploadDate setText:@"Now"];
                         }
                         
                         self.stringUploadDate.alpha = 1.0f;
    } completion:nil];
}


- (void)configurePrivacyButton
{
    if ([self.string.parseString.ACL getPublicWriteAccess]) {
        self.stringPrivacySettings.image = [UIImage imageNamed:@"unlock_button"];
    }
    else {
        self.stringPrivacySettings.image = [UIImage imageNamed:@"lock_button"];
    }
}


#pragma mark - IBActions

- (IBAction)viewStringPhotosButtonTouched:(UIButton *)sender
{
    [self.delegate stringHeader:self didTapPhotoViewForString:self.string];
}


#pragma mark - Actions

- (void)profileImageTapped
{
    if ([self.delegate respondsToSelector:@selector(profileImageTappedForUser:)]) {
        [self.delegate profileImageTappedForUser:self.string.uploader];
    }
}



@end
