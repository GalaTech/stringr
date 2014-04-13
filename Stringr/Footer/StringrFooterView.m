//
//  StringrFooterView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFooterView.h"

@interface StringrFooterView ()

@property (strong, nonatomic) PFObject *objectForFooterView; // The string or photo object associated with this view
@property (strong, nonatomic) PFUser *userForObject;

@property (strong, nonatomic) StringrPathImageView *profileImageView;
@property (strong, nonatomic) UILabel *profileNameLabel;
@property (strong, nonatomic) UIButton *profileImageButton;

@property (strong, nonatomic) UILabel *uploadDateLabel;
@property (strong, nonatomic) UILabel *commentsTextLabel;
@property (strong, nonatomic) UILabel *likesTextLabel;

@property (strong, nonatomic) UIImageView *commentsImageView;
@property (strong, nonatomic) UIButton *commentsButton;

@property (strong, nonatomic) UIImageView *likesImageView;
@property (strong, nonatomic) UIButton *likesButton;

@end


@implementation StringrFooterView

#pragma mark - Lifecycle

static float const contentViewWidth = 320.0;
//static float const contentViewHeight = 41.5;
//static float const contentFooterViewWidthPercentage = .93;

- (UIView *)initWithFrame:(CGRect)frame fullWidthCell:(BOOL)isFullWidthCell withObject:(PFObject *)object
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:1.0];
        
        
        float nameAndUploadDateXLocation;
        float commentsButtonXLocation;
        float likesButtonXLocation;
        float profileImageXLocationPercentage;
        
        if (isFullWidthCell) {
            nameAndUploadDateXLocation = CGRectGetWidth(frame) * .185;
            commentsButtonXLocation = CGRectGetWidth(frame) * .52;
            likesButtonXLocation = CGRectGetWidth(frame) * .73;
            profileImageXLocationPercentage = .05;
        } else {
            nameAndUploadDateXLocation = CGRectGetWidth(frame) * .14;
            commentsButtonXLocation = CGRectGetWidth(frame) * .49;
            likesButtonXLocation = CGRectGetWidth(frame) * .715;
            profileImageXLocationPercentage = .02;
        }
        
        self.objectForFooterView = object;
        
        [self addProfileImageViewAtLocation:CGPointMake(CGRectGetWidth(frame) * profileImageXLocationPercentage, 2) withSize:CGSizeMake(contentViewWidth * .115, contentViewWidth * .115)];
        [self addProfileNameLabelAtLocation:CGPointMake(nameAndUploadDateXLocation, 6) withSize:CGSizeMake(130, 13)];
        [self addUploadDateLabelAtLocation:CGPointMake(nameAndUploadDateXLocation, 22) withSize:CGSizeMake(130, 13)];
        [self addCommentsButtonAtLocation:CGPointMake(commentsButtonXLocation, 12) withSize:CGSizeMake(40, 18)];
        [self addLikesButtonAtLocation:CGPointMake(likesButtonXLocation, 12) withSize:CGSizeMake(40, 18)];
        
        [self setupFooterViewWithObject:object];
    }
    
    return self;
}




#pragma mark - Public

- (void)setupFooterViewWithObject:(PFObject *)object
{
    [self setUploaderProfileInformation];
    [self setUploadDate];
    [self setCommentsWithObject:object];
    [self setLikesWithObject:object];
}

- (void)refreshLikesAndComments
{
    [self setCommentsWithObject:self.objectForFooterView];
    [self setLikesWithObject:self.objectForFooterView];
}



#pragma mark - Private

- (void)setUploaderProfileInformation
{
    if (self.objectForFooterView) {
        [self loadingProfileImageIndicatorEnabled:YES];
        
        PFUser *stringUploader = [self.objectForFooterView objectForKey:kStringrStringUserKey];
        [stringUploader fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            self.userForObject = (PFUser *)user;
            [self.profileNameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[user objectForKey:kStringrUserUsernameCaseSensitive]]];
            
            PFFile *uploaderProfileImageFile = [user objectForKey:kStringrUserProfilePictureThumbnailKey];
            
            [self.profileImageView setFile:uploaderProfileImageFile];
            [self.profileImageView loadInBackground];
            [self loadingProfileImageIndicatorEnabled:NO];
        }];
    } else {
        [self.profileNameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]]];
        
        PFFile *currentUserProfileImageFile = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureThumbnailKey];
        [self.profileImageView setFile:currentUserProfileImageFile];
        [self.profileImageView loadInBackground];
    }
}

- (void)setUploadDate
{
    if (self.objectForFooterView) {
        NSString *uploadTime = [StringrUtility timeAgoFromDate:self.objectForFooterView.createdAt];
        [self.uploadDateLabel setText:uploadTime];
    } else {
        [self.uploadDateLabel setText:@"Now"];
    }
}

- (void)setCommentsWithObject:(PFObject *)object
{
    if (object) {
        // sets up the comments button/label with the number of comments the object has
        NSString *commentKey = kStringrStringNumberOfCommentsKey;
        if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            commentKey = kStringrPhotoNumberOfCommentsKey;
        }
        
        NSNumber *numberOfComments = [object objectForKey:commentKey];
        
        [self.commentsTextLabel setText:[NSString stringWithFormat:@"%d", [numberOfComments intValue]]];
    } else {
        [self.commentsButton setEnabled:NO];
        [self.commentsTextLabel setText:[NSString stringWithFormat:@"0"]];
    }
}

- (void)setLikesWithObject:(PFObject *)object
{
    if (object) {
        // sets up the like button/label with the number of likes the object has
        NSString *likeKey = kStringrStringNumberOfLikesKey;
        if ([object.parseClassName isEqualToString:kStringrPhotoClassKey]) {
            likeKey = kStringrPhotoNumberOfLikesKey;
        }
        
        NSNumber *numberOfLikes = [object objectForKey:likeKey];
        [self.likesTextLabel setText:[NSString stringWithFormat:@"%d", [numberOfLikes intValue]]];
    } else {
        [self.likesButton setEnabled:NO];
        [self.likesTextLabel setText:@"0"];
    }
}

- (void)loadingProfileImageIndicatorEnabled:(BOOL)enabled
{
    if (enabled) {
        [self.loadingProfileImageIndicator startAnimating];
        [self.loadingProfileImageIndicator setHidden:NO];
    } else {
        [self.loadingProfileImageIndicator stopAnimating];
        [self.loadingProfileImageIndicator setHidden:YES];
    }
}


- (void)addProfileImageViewAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)
                                                                  image:nil
                                                              pathColor:[UIColor darkGrayColor]
                                                              pathWidth:1.0];
    [self.profileImageView setBackgroundColor:[StringrConstants kStringTableViewBackgroundColor]];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    //[self.profileImageView setUserInteractionEnabled:YES];
    
    self.loadingProfileImageIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(location.x + ((size.width - (size.width / 2)) / 2), location.y + ((size.height - (size.height / 2)) / 2), size.width / 2, size.height / 2)];
    [self.loadingProfileImageIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    self.profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.profileImageButton addTarget:self action:@selector(pushProfilePicture) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.profileImageView];
    [self addSubview:self.loadingProfileImageIndicator];
    [self addSubview:self.profileImageButton];
}

- (void)pushProfilePicture
{
    [self.delegate stringrFooterView:self didTapUploaderProfileImageButton:self.profileImageButton uploader:self.userForObject];
}

- (void)addProfileNameLabelAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    
    [self.profileNameLabel setText:@""];
    [self.profileNameLabel setTextColor:[UIColor grayColor]];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [self addSubview:self.profileNameLabel];
}

- (void)addUploadDateLabelAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    
    
    [self.uploadDateLabel setText:@"0 Minutes Ago"];
    [self.uploadDateLabel setTextColor:[UIColor grayColor]];
    [self.uploadDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.uploadDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:9]];
    [self addSubview:self.uploadDateLabel];
}

- (void)addCommentsButtonAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.commentsTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.commentsTextLabel setText:@"0"];
    [self.commentsTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [self.commentsTextLabel setTextColor:[UIColor lightGrayColor]];
    [self.commentsTextLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.commentsTextLabel];

    self.commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x + 5, location.y - 5, 65, 27)];
    [self.commentsButton setImage:[UIImage imageNamed:@"comment_button"] forState:UIControlStateNormal];
    [self.commentsButton setImageEdgeInsets:UIEdgeInsetsMake(4, 40, 4, 0)];
    [self.commentsButton addTarget:self action:@selector(pushCommentsButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.commentsButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self addSubview:self.commentsButton];
}

// Sends user to current strings comments section and changes text color
- (void)pushCommentsButton
{
    [self.delegate stringrFooterView:self didTapCommentButton:self.commentsButton objectToCommentOn:self.objectForFooterView];
}

- (void)addLikesButtonAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.likesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.likesTextLabel setText:@""];
    [self.likesTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [self.likesTextLabel setTextColor:[UIColor lightGrayColor]];
    [self.likesTextLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.likesTextLabel];
    
    self.likesButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x + 5, location.y - 5, 65, 27)];
    [self.likesButton setImage:[UIImage imageNamed:@"like_button"] forState:UIControlStateNormal];
    [self.likesButton setImage:[UIImage imageNamed:@"like_button_selected"] forState:UIControlStateSelected];
    [self.likesButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 7, 5)];
    [self.likesButton addTarget:self action:@selector(likesButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.likesButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self addSubview:self.likesButton];
    
}

// increments the number of likes for the current string and changes text color
- (void)likesButtonTouchHandler:(UIButton *)button
{
    BOOL liked = !button.selected;
    [self setLikesButtonState:liked];
    
    [[StringrCache sharedCache] setStringIsLikedByCurrentUser:self.objectForFooterView liked:liked];
    
    if (liked) {
        [[StringrCache sharedCache] incrementLikeCountForString:self.objectForFooterView];
        
        [StringrUtility likeStringInBackground:self.objectForFooterView block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self setLikesButtonState:NO];
            } else {
                [self refreshLikesAndComments];
            }
        }];
    } else {
        [[StringrCache sharedCache] decrementLikeCountForString:self.objectForFooterView];
        
        [StringrUtility unlikeStringInBackground:self.objectForFooterView block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [self setLikesButtonState:YES];
            } else {
                [self refreshLikesAndComments];
            }
        }];
    }
    
    [self.delegate stringrFooterView:self didTapLikeButton:self.likesButton objectToLike:self.objectForFooterView];
}

- (void)setLikesButtonState:(BOOL)selected
{
    if (selected) {
        [self.likesButton setSelected:YES];
    } else {
         [self.likesButton setSelected:NO];
    }
}






@end
