//
//  TestTableViewHeader.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewHeader.h"
#import "StringrPathImageView.h"

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
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        
        
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.stringProfileImage setupImageWithDefaultConfiguration];
    
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
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self configureProfileImageViewWithUser:(PFUser *)object];
        [self configureProfileUploaderLabelWithUser:(PFUser *)object];
    }];
}


#pragma mark - Private

- (void)configureProfileImageViewWithUser:(PFUser *)user
{
    [self.stringProfileImage setFile:user[kStringrUserProfilePictureThumbnailKey]];
    [self.stringProfileImage loadInBackgroundWithIndicator];
}


- (void)configureProfileUploaderLabelWithUser:(PFUser *)user
{
    NSString *formattedUsername = [StringrUtility usernameFormattedWithMentionSymbol:user[kStringrUserUsernameCaseSensitive]];
    self.stringProfileUploader.text = formattedUsername;
}


- (void)configureUploadDateLabel
{
    if (self.headerString) {
        NSString *uploadTime = [StringrUtility timeAgoFromDate:self.headerString.createdAt];
        [self.stringUploadDate setText:uploadTime];
    } else {
        [self.stringUploadDate setText:@"Now"];
    }
}

@end
