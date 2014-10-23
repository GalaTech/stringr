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

@property (strong, nonatomic) PFObject *headerString;

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


#pragma mark - Public

- (void)configureHeaderWithString:(PFObject *)string
{
    self.headerString = string;
    
    PFUser *user = self.headerString[kStringrStringUserKey];
    
    [user fetchUserIfNeededInBackgroundWithBlock:^(PFUser *user, NSError *error) {
        [self configureProfileImageViewWithUser:user];
        [self configureProfileUploaderLabelWithUser:user];
    }];
    
    [self configureUploadDateLabel];
}


#pragma mark - Private

- (void)setupAppearance
{
    [self.stringProfileImage setupImageWithDefaultConfiguration];
    [self.stringProfileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    self.stringProfileUploader.font = [UIFont stringrHeaderPrimaryLabelFont];
    self.stringProfileUploader.textColor = [UIColor stringrPrimaryLabelColor];
    
    self.stringUploadDate.font = [UIFont stringrHeaderSecondaryLabelFont];
    self.stringUploadDate.textColor = [UIColor stringrSecondaryLabelColor];
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
    self.stringProfileUploader.text = formattedUsername;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.stringProfileUploader.alpha = 1.0f;
    } completion:nil];
}


- (void)configureUploadDateLabel
{
    if (self.headerString) {
        NSString *uploadTime = [StringrUtility timeAgoFromDate:self.headerString.createdAt];
        [self.stringUploadDate setText:uploadTime];
    } else {
        [self.stringUploadDate setText:@"Now"];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.stringUploadDate.alpha = 1.0f;
    } completion:nil];
}


#pragma mark - Actions

- (void)profileImageTapped
{
    if ([self.delegate respondsToSelector:@selector(profileImageTappedForUser:)]) {
        [self.delegate profileImageTappedForUser:self.headerString[kStringrStringUserKey]];
    }
}

@end
