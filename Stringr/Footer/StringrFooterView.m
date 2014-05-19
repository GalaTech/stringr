//
//  StringrFooterView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFooterView.h"
#import "StringrPathImageView.h"

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
    [self setCommentsAndLikesWithObject:object];
    //[self setCommentsWithObject:object];
    //[self setLikesWithObject:object];
}

- (void)refreshLikesAndComments
{
    [self setCommentsAndLikesWithObject:self.objectForFooterView];
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
            [self.profileImageView loadInBackgroundWithIndicator];
            [self loadingProfileImageIndicatorEnabled:NO];
        }];
    } else {
        [self.profileNameLabel setText:[StringrUtility usernameFormattedWithMentionSymbol:[[PFUser currentUser] objectForKey:kStringrUserUsernameCaseSensitive]]];
        
        PFFile *currentUserProfileImageFile = [[PFUser currentUser] objectForKey:kStringrUserProfilePictureThumbnailKey];
        [self.profileImageView setFile:currentUserProfileImageFile];
        [self.profileImageView loadInBackgroundWithIndicator];
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

/*
- (void)setCommentsWithObject:(PFObject *)object
{
    if (object) {
        PFQuery *commentCountQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
        [commentCountQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeComment];
        
        if ([StringrUtility objectIsString:object]) {
            [commentCountQuery whereKey:kStringrActivityStringKey equalTo:object];
        } else {
            [commentCountQuery whereKey:kStringrActivityPhotoKey equalTo:object];
        }
        
        [commentCountQuery whereKeyExists:kStringrActivityFromUserKey];
        [commentCountQuery countObjectsInBackgroundWithBlock:^(int numberOfComments, NSError *error) {
            if (!error) {
                [self.commentsTextLabel setText:[NSString stringWithFormat:@"%d", numberOfComments]];
            }
        }];
    } else {
        [self.commentsButton setEnabled:NO];
        [self.commentsTextLabel setText:[NSString stringWithFormat:@"0"]];
    }
}

- (void)setLikesWithObject:(PFObject *)object
{
    if (object) {
        
        NSDictionary *objectAttributes = [[StringrCache sharedCache] attributesForObject:object];
        
        if (objectAttributes) {
            [self setLikesButtonState:[[StringrCache sharedCache] isObjectLikedByCurrentUser:object]];
        } else {
        
            PFQuery *likeCountQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
            [likeCountQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
            
            
            
            
            if ([StringrUtility objectIsString:object]) {
                [likeCountQuery whereKey:kStringrActivityStringKey equalTo:object];
            } else {
                [likeCountQuery whereKey:kStringrActivityPhotoKey equalTo:object];
            }
            [likeCountQuery whereKeyExists:kStringrActivityFromUserKey];
            
            [likeCountQuery findObjectsInBackgroundWithBlock:^(NSArray *activityObjects, NSError *error) {
                
                NSMutableArray *likers = [[NSMutableArray alloc] init];
                NSMutableArray *commentors = [[NSMutableArray alloc] init];
                
                for (PFObject *activity in activityObjects) {
                    if ([[activity objectForKey:kStringrActivityTypeKey] isEqualToString:kStringrActivityTypeLike] && [activity objectForKey:kStringrActivityFromUserKey]) {
                        
                        PFUser *likerUser = [activity objectForKey:kStringrActivityFromUserKey];
                        if (![likers containsObject:likerUser]) {
                            [likers addObject:likerUser];
                        }
                        
                        if ([likerUser.objectId isEqualToString:[PFUser currentUser].objectId]) {
                            [self setLikesButtonState:YES];
                            [[StringrCache sharedCache] setObjectIsLikedByCurrentUser:object liked:YES];
                        }
                    }
                }
                
                [self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likers.count]];
                
            }];
            
        }
    } else {
        [self.likesButton setEnabled:NO];
        [self.likesTextLabel setText:@"0"];
    }
}
*/


- (void)setCommentsAndLikesWithObject:(PFObject *)object
{
    if (object) {
        
        NSDictionary *objectAttributes = [[StringrCache sharedCache] attributesForObject:object];
        //NSDictionary *objectAttributes = nil;
        if (objectAttributes) {
            [self setLikesButtonState:[[StringrCache sharedCache] isObjectLikedByCurrentUser:object]];
            
            int likeCount = [[[StringrCache sharedCache] likeCountForObject:object] intValue];
            [self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likeCount]];
            
            int commentCount = [[[StringrCache sharedCache] commentCountForObject:object] intValue];
            [self.commentsTextLabel setText:[NSString stringWithFormat:@"%d", commentCount]];
        } else {
            // set alpha to 0 so that they can later fade in
            [self.likesTextLabel setAlpha:0.0f];
            [self.commentsTextLabel setAlpha:0.0f];
            
            @synchronized(self) {
                PFQuery *objectActivitiesQuery = [StringrUtility queryForActivitiesOnObject:object cachePolicy:kPFCachePolicyNetworkOnly];
                [objectActivitiesQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
                    if (error) {
                        return;
                    }
                    
                    NSMutableArray *likers = [[NSMutableArray alloc] init];
                    NSMutableArray *commentors = [[NSMutableArray alloc] init];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in activities) {
                         PFUser *likerUser = [activity objectForKey:kStringrActivityFromUserKey];
                        
                        // add user to likers array if they like the current string/photo
                        if ([[activity objectForKey:kStringrActivityTypeKey] isEqualToString:kStringrActivityTypeLike] && [activity objectForKey:kStringrActivityFromUserKey]) {
                            
                            if (![likers containsObject:likerUser]) {
                                [likers addObject:likerUser];
                            }
                            
                            // if the current user is one of the likers we set them to liking the string/photo
                            if ([[likerUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                isLikedByCurrentUser = YES;
                            }
                            
                            // add user to commentors if they commented on the current string/photo
                        } else if ([[activity objectForKey:kStringrActivityTypeKey] isEqualToString:kStringrActivityTypeComment] && [activity objectForKey:kStringrActivityFromUserKey]) {
                            [commentors addObject:likerUser];
                        }
                    }
                    
                    [[StringrCache sharedCache] setAttributesForObject:object likeCount:@(likers.count) commentCount:@(commentors.count) likedByCurrentUser:isLikedByCurrentUser];
                    
                    [self setLikesButtonState:isLikedByCurrentUser];
                    
                    [UIView animateWithDuration:0.5 animations:^ {
                        [self.likesTextLabel setAlpha:1.0f];
                        [self.likesTextLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)likers.count]];
                        
                        [self.commentsTextLabel setAlpha:1.0f];
                        [self.commentsTextLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)commentors.count]];
                    }];
                    
                }];
            }
        }
    }
    /*
    else {
        [self.likesButton setEnabled:NO];
        [self.likesTextLabel setText:@"0"];
    }
     */
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
    [self.commentsTextLabel setText:@""];
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

// Sends user to current strings/photos comments section and changes text color
- (void)pushCommentsButton
{
    if (self.objectForFooterView) {
        if ([self.delegate respondsToSelector:@selector(stringrFooterView:didTapCommentButton:objectToCommentOn:inSection:)]) {
            [self.delegate stringrFooterView:self didTapCommentButton:self.commentsButton objectToCommentOn:self.objectForFooterView inSection:self.section];
        }
    }
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
    if (self.objectForFooterView) {
        [self shouldEnableLikeButton:NO];
        
        BOOL liked = !button.selected;
        [self setLikesButtonState:liked];
        [[StringrCache sharedCache] setObjectIsLikedByCurrentUser:self.objectForFooterView liked:liked];
        
        int likeCount = [self.likesTextLabel.text intValue];
        
        if (liked) {
            [[StringrCache sharedCache] incrementLikeCountForObject:self.objectForFooterView];
            [self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likeCount + 1]];
            
            [StringrUtility likeObjectInBackground:self.objectForFooterView block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self shouldEnableLikeButton:YES];
                    [self setLikesButtonState:succeeded];
                } else {
                    //[self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likeCount]];
                }
            }];
        } else {
            [[StringrCache sharedCache] decrementLikeCountForObject:self.objectForFooterView];
            [self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likeCount - 1]];
            
            [StringrUtility unlikeObjectInBackground:self.objectForFooterView block:^(BOOL succeeded, NSError *error) {
                [self shouldEnableLikeButton:YES];
                [self setLikesButtonState:!succeeded];
                
                if (!succeeded) {
                    //[self.likesTextLabel setText:[NSString stringWithFormat:@"%d", likeCount]]; // having this enabled results in a 'flicker' of liking. 
                }
            }];
        }
        
        if ([self.delegate respondsToSelector:@selector(stringrFooterView:didTapLikeButton:objectToLike:inSection:)]) {
            [self.delegate stringrFooterView:self didTapLikeButton:self.likesButton objectToLike:self.objectForFooterView inSection:self.section];
        }
    }
}

- (void)setLikesButtonState:(BOOL)selected
{
    if (selected) {
        [self.likesButton setSelected:YES];
    } else {
         [self.likesButton setSelected:NO];
    }
}

- (void)shouldEnableLikeButton:(BOOL)enable
{
    if (enable) {
        [self.likesButton addTarget:self action:@selector(likesButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likesButton removeTarget:self action:@selector(likesButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end

