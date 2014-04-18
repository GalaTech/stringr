//
//  StringrActivityTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 4/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrActivityTableViewCell.h"
#import "StringrPathImageView.h"

@interface StringrActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet StringrPathImageView *activityCellProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *activityCellTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityCellDateLabel;

@property (strong, nonatomic) PFUser *userForActivityCell;
@property (nonatomic) NSUInteger rowNumberForActivityCell;

@end

@implementation StringrActivityTableViewCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self.activityCellProfileImage setPathColor:[UIColor darkGrayColor]];
    [self.activityCellProfileImage setPathWidth:1.0f];
    [self.activityCellProfileImage setImageToCirclePath];
    [self.activityCellProfileImage setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.activityCellProfileImage setContentMode:UIViewContentModeScaleAspectFill];
    
    CGFloat xPoint = CGRectGetMinX(self.activityCellProfileImage.frame);
    CGFloat yPoint = CGRectGetMinY(self.activityCellProfileImage.frame);

    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPoint, yPoint, 39, 40)];
    [profileImageButton addTarget:self action:@selector(tapUserProfileImageButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:profileImageButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




#pragma mark - Public

- (void)setObjectForActivityCell:(PFObject *)object
{
    [self setupActivityCellWithActivityType:[object objectForKey:kStringrActivityTypeKey] andObject:object];
}

- (void)setRowForActivityCell:(NSUInteger)row
{
    self.rowNumberForActivityCell = row;
}




#pragma mark - Private

- (void)setupActivityCellWithActivityType:(NSString *)activityType andObject:(PFObject *)object
{
    NSString *receiverObjectTypeName;
    
    if ([object objectForKey:kStringrActivityStringKey]) {
        receiverObjectTypeName = @"String";
    } else if ([object objectForKey:kStringrActivityPhotoKey]) {
        receiverObjectTypeName = @"Photo";
    }
    
    if ([activityType isEqualToString:kStringrActivityTypeLike]) {
        
        PFUser *activityUser = [object objectForKey:kStringrActivityFromUserKey];
        [activityUser fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                _userForActivityCell = (PFUser *)user;
                
                NSString *activityUserFormattedUsername = [StringrUtility usernameFormattedWithMentionSymbol:[user objectForKey:kStringrUserUsernameCaseSensitive]];
                NSString *likedObjectText = [NSString stringWithFormat:@"%@ liked your %@", activityUserFormattedUsername, receiverObjectTypeName];
               
                NSMutableAttributedString *activityText = [[NSMutableAttributedString alloc] initWithString:likedObjectText];
                NSRange textBeyondUsername = NSMakeRange(activityUserFormattedUsername.length, likedObjectText.length - activityUserFormattedUsername.length);
                NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:13], NSFontAttributeName,
                                                [UIColor grayColor], NSForegroundColorAttributeName, nil];
                
                [activityText setAttributes:textAttributes range:textBeyondUsername];
                
                [self.activityCellTextLabel setAttributedText:activityText];
                
                
                
                PFFile *activityUserProfileImage = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
                [self.activityCellProfileImage setFile:activityUserProfileImage];
                [self.activityCellProfileImage loadInBackground];
            }
        }];
        
        NSString *activityUploadDate = [StringrUtility timeAgoFromDate:object.createdAt];
        [self.activityCellDateLabel setText:activityUploadDate];
        
    } else if ([activityType isEqualToString:kStringrActivityTypeComment]) {
        
        PFUser *activityUser = [object objectForKey:kStringrActivityFromUserKey];
        [activityUser fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                _userForActivityCell = (PFUser *)user;
                
                NSString *activityUserFormattedUsername = [StringrUtility usernameFormattedWithMentionSymbol:[user objectForKey:kStringrUserUsernameCaseSensitive]];
                NSString *commentedObjectText = [NSString stringWithFormat:@"%@ commented on your %@", activityUserFormattedUsername, receiverObjectTypeName];
                
                NSMutableAttributedString *activityText = [[NSMutableAttributedString alloc] initWithString:commentedObjectText];
                NSRange textBeyondUsername = NSMakeRange(activityUserFormattedUsername.length, commentedObjectText.length - activityUserFormattedUsername.length);
                NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:13], NSFontAttributeName,
                                                [UIColor grayColor], NSForegroundColorAttributeName, nil];
                
                [activityText setAttributes:textAttributes range:textBeyondUsername];
                
                [self.activityCellTextLabel setAttributedText:activityText];
                
                PFFile *activityUserProfileImage = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
                [self.activityCellProfileImage setFile:activityUserProfileImage];
                [self.activityCellProfileImage loadInBackground];
            }
        }];
        
        NSString *activityUploadDate = [StringrUtility timeAgoFromDate:object.createdAt];
        [self.activityCellDateLabel setText:activityUploadDate];
    } else if ([activityType isEqualToString:kStringrActivityTypeFollow]) {
        PFUser *activityUser = [object objectForKey:kStringrActivityFromUserKey];
        [activityUser fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                _userForActivityCell = (PFUser *)user;
                
                NSString *activityUserFormattedUsername = [StringrUtility usernameFormattedWithMentionSymbol:[user objectForKey:kStringrUserUsernameCaseSensitive]];
                NSString *followedUserText = [NSString stringWithFormat:@"%@ followed you!", activityUserFormattedUsername];
               
                NSMutableAttributedString *activityText = [[NSMutableAttributedString alloc] initWithString:followedUserText];
                NSRange textBeyondUsername = NSMakeRange(activityUserFormattedUsername.length, followedUserText.length - activityUserFormattedUsername.length);
                NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: [UIFont fontWithName:@"HelveticaNeue-Light" size:13], NSFontAttributeName,
                                                [UIColor grayColor], NSForegroundColorAttributeName, nil];
                
                [activityText setAttributes:textAttributes range:textBeyondUsername];
                
                [self.activityCellTextLabel setAttributedText:activityText];
                
                
                PFFile *activityUserProfileImage = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
                [self.activityCellProfileImage setFile:activityUserProfileImage];
                [self.activityCellProfileImage loadInBackground];
            }
        }];
        
        NSString *activityUploadDate = [StringrUtility timeAgoFromDate:object.createdAt];
        [self.activityCellDateLabel setText:activityUploadDate];
    }
}

- (void)tapUserProfileImageButtonTouchHandler
{
    [self.delegate tappedActivityUserProfileImage:self.userForActivityCell];
}


- (void)setUserForActivityCell:(PFUser *)user
{
    
}

- (void)setTextContentForActivityCell:(NSString *)text
{
    [self.activityCellTextLabel setText:text];
}

- (void)setUploadDateForActivityCell:(NSString *)date
{
    [self.activityCellDateLabel setText:date];
}


@end
