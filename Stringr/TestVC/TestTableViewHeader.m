//
//  TestTableViewHeader.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewHeader.h"
#import "StringrPathImageView.h"
#import "UIFont+StringrFonts.h"
#import "UIColor+StringrColors.h"
#import "PFUser+StringrAdditions.h"

@interface TestTableViewHeader ()

@property (weak, nonatomic) IBOutlet StringrPathImageView *stringProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *stringProfileUploader;
@property (weak, nonatomic) IBOutlet UILabel *stringUploadDate;
@property (weak, nonatomic) IBOutlet UIImageView *stringPrivacySettings;
@property (strong, nonatomic) IBOutlet UIButton *stringInfoButton;

@property (strong, nonatomic, readwrite) PFObject *string;

@end

@implementation TestTableViewHeader

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

- (void)configureHeaderWithString:(PFObject *)string
{
    self.string = string;
    
    PFUser *user = self.string[kStringrStringUserKey];
    
    [user fetchUserIfNeededInBackgroundWithBlock:^(PFUser *user, NSError *error) {
        [self configureProfileImageViewWithUser:user];
        [self configureProfileUploaderLabelWithUser:user];
        [self configureUploadDateLabel];
    }];
    
    [self configureStringInfoButton];
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
    
    self.stringInfoButton.hidden = !self.editingEnabled;
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
    NSString *formattedUsername = [StringrUtility usernameFormattedWithMentionSymbol:user[kStringrUserUsernameCaseSensitive]];
    
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
                             NSString *uploadTime = [StringrUtility timeAgoFromDate:self.string.createdAt];
                             [self.stringUploadDate setText:uploadTime];
                         } else {
                             [self.stringUploadDate setText:@"Now"];
                         }
                         
                         self.stringUploadDate.alpha = 1.0f;
    } completion:nil];
}


- (void)configureStringInfoButton
{
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.stringInfoButton.hidden = !self.editingEnabled;
                         self.stringInfoButton.alpha = self.stringInfoButton.hidden ? 0.0f : 1.0f;
    } completion:nil];
}


- (void)configurePrivacyButton
{
    if ([self.string.ACL getPublicWriteAccess]) {
        self.stringPrivacySettings.image = [UIImage imageNamed:@"unlock_button"];
    }
    else {
        self.stringPrivacySettings.image = [UIImage imageNamed:@"lock_button"];
    }
}


#pragma mark - IBActions

- (IBAction)tappedInfoButton:(UIButton *)sender
{
    [self infoButtonTapped];
}

#pragma mark - Actions

- (void)profileImageTapped
{
    if ([self.delegate respondsToSelector:@selector(profileImageTappedForUser:)]) {
        [self.delegate profileImageTappedForUser:self.string[kStringrStringUserKey]];
    }
}


- (void)infoButtonTapped
{
    if ([ self.delegate respondsToSelector:@selector(testTableViewHeader:tappedInfoButton:)]) {
        [self.delegate testTableViewHeader:self tappedInfoButton:self.stringInfoButton];
    }
}

@end
