//
//  StringrFooterView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrFooterView.h"

@interface StringrFooterView ()

@property (strong, nonatomic) UIImageView *commentsImageView;
@property (strong, nonatomic) UIButton *commentsButton;

@property (strong, nonatomic) UIImageView *likesImageView;
@property (strong, nonatomic) UIButton *likesButton;

@end


@implementation StringrFooterView

#pragma mark - Lifecycle

static float const contentViewWidth = 320.0;
static float const contentViewHeight = 41.5;
static float const contentFooterViewWidthPercentage = .93;

- (UIView *)initWithFrame:(CGRect)frame withFullWidthCell:(BOOL)isFullWidthCell
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
        
        [self addProfileImageViewAtLocation:CGPointMake(CGRectGetWidth(frame) * profileImageXLocationPercentage, 2) withSize:CGSizeMake(contentViewWidth * .115, contentViewWidth * .115)];
        [self addProfileNameLabelAtLocation:CGPointMake(nameAndUploadDateXLocation, 6) withSize:CGSizeMake(130, 13)];
        [self addUploadDateLabelAtLocation:CGPointMake(nameAndUploadDateXLocation, 22) withSize:CGSizeMake(130, 13)];
        [self addCommentsButtonAtLocation:CGPointMake(commentsButtonXLocation, 12) withSize:CGSizeMake(40, 18)];
        [self addLikesButtonAtLocation:CGPointMake(likesButtonXLocation, 12) withSize:CGSizeMake(40, 18)];
    }
    
    return self;
}




#pragma mark - Private

- (void)addProfileImageViewAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)
                                                                  image:[UIImage imageNamed:@"alonsoAvatar.jpg"]
                                                              pathColor:[UIColor darkGrayColor]
                                                              pathWidth:1.0];
    [self.profileImageView setUserInteractionEnabled:YES];
    
    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [profileImageButton addTarget:self action:@selector(pushProfilePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.profileImageView];
    [self addSubview:profileImageButton];
}

- (void)pushProfilePicture:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectProfileImage" object:nil];
}

- (void)addProfileNameLabelAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    
    [self.profileNameLabel setText:@"Stringr User"];
    [self.profileNameLabel setTextColor:[UIColor grayColor]];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    //[self.profileNameLabel setBackgroundColor:[UIColor purpleColor]];
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
    [self.commentsTextLabel setTextColor:[UIColor grayColor]];
    [self.commentsTextLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.commentsTextLabel];
    
    self.commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x + 45, location.y, 20, 17)];
    [self.commentsImageView setImage:[UIImage imageNamed:@"comment-bubble.png"]];
    [self addSubview:self.commentsImageView];
    
    self.commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, 65, 18)];
    [self.commentsButton addTarget:self action:@selector(pushDownCommentsButton) forControlEvents:UIControlEventTouchDown];
    [self.commentsButton addTarget:self action:@selector(pushCommentsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsButton addTarget:self action:@selector(pushCommentsOutside) forControlEvents:UIControlEventTouchUpOutside];
    //[self.commentsButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self addSubview:self.commentsButton];
}

// Sends user to current strings comments section and changes text color
- (void)pushCommentsButton
{
    self.commentsTextLabel.textColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectCommentsButton" object:nil];
}

// alters text color in a way that makes it look like the button was presed
- (void)pushDownCommentsButton
{
    self.commentsTextLabel.textColor = [UIColor darkGrayColor];
}

- (void)pushCommentsOutside
{
    self.commentsTextLabel.textColor = [UIColor grayColor];
}

- (void)addLikesButtonAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.likesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.likesTextLabel setText:@"0"];
    [self.likesTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [self.likesTextLabel setTextColor:[UIColor grayColor]];
    [self.likesTextLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.likesTextLabel];
    
    self.likesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x + 45, location.y - 2, 20, 17)];
    [self.likesImageView setImage:[UIImage imageNamed:@"like-bubble.png"]];
    [self addSubview:self.likesImageView];
    
    self.likesButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, 65, 18)];
    [self.likesButton addTarget:self action:@selector(pushDownLikesButton) forControlEvents:UIControlEventTouchDown];
    [self.likesButton addTarget:self action:@selector(pushLikesButton) forControlEvents:UIControlEventTouchUpInside];
    [self.likesButton addTarget:self action:@selector(pushLikesOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    //[self.likesButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self addSubview:self.likesButton];
    
}

// increments the number of likes for the current string and changes text color
- (void)pushLikesButton
{
    self.likesTextLabel.textColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectLikesButton" object:nil];
}

// alters text color in a way that makes it look like the button was presed
- (void)pushDownLikesButton
{
    self.likesTextLabel.textColor = [UIColor darkGrayColor];
}

- (void)pushLikesOutside
{
    self.likesTextLabel.textColor = [UIColor grayColor];
}


@end
