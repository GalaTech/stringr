//
//  StringFooterTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/23/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringFooterTableViewCell.h"

#import "StringrPathImageView.h"


@interface StringFooterTableViewCell ()

@property (strong, nonatomic) UIView *contentFooterView;

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

// Standard color used for table view BG
#define veryLightGrayColor [UIColor colorWithWhite:0.9 alpha:1.0]

#define contentViewWidth self.contentView.frame.size.width
#define contentViewHeight 41.5
#define contentViewWidthPercentage .93

#define profileImageXLocationPercentage .02

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView setBackgroundColor:veryLightGrayColor];

        
        // Creates the custom footer content view
        float xpoint = (self.contentView.frame.size.width - (self.contentView.frame.size.width * contentViewWidthPercentage)) / 2;
        self.contentFooterView = [[UIView alloc] initWithFrame:CGRectMake(xpoint, 0, contentViewWidth * contentViewWidthPercentage, contentViewHeight)];
        [self.contentFooterView setBackgroundColor:[UIColor whiteColor]];
        [self.contentFooterView setAlpha:1];
        
        [self addProfileImageViewAtLocation:CGPointMake(self.contentView.frame.size.width * profileImageXLocationPercentage, 2) withSize:CGSizeMake(contentViewWidth * .115, contentViewWidth * .115)];
        
        // Adds profile label with provided profile name at location with size
        [self addProfileNameLabelAtLocation:CGPointMake(42, 6) withSize:CGSizeMake(130, 13)];
        
        // Adds upload date label with the date the current string was uploaded
        [self addUploadDateLabelAtLocation:CGPointMake(42, 22) withSize:CGSizeMake(130, 13)];
        
        // Adds comments button to the table cell content view at location
        [self addCommentsButtonAtLocation:CGPointMake(157, 11) withSize:CGSizeMake(40, 18)];
    
        // Adds likes button to the table cell content view at location
        [self addLikesButtonAtLocation:CGPointMake(222, 11) withSize:CGSizeMake(40, 18)];
        
        
        [self.contentView addSubview:self.contentFooterView];
    }
    
    return self;
}


/*
- (UIImage *)stringUploaderProfileImage
{
    return [UIImage imageNamed:@"alonsoAvatar.jpg"];
}

- (NSString *)stringUploaderName
{
    return @"Alonso Holmes";
}

- (NSString *)stringUploadDate
{
    return @"10 minutes ago";
}
 */

/*
- (void)setStringUploaderProfileImage:(UIImage *)stringUploaderProfileImage
{
    _stringUploaderProfileImage = stringUploaderProfileImage;

    if (_stringUploaderProfileImage) {
        self.profileImageView = [[GBPathImageView alloc] initWithFrame:CGRectMake(7, 2, 30, 30)
                                                                 image:_stringUploaderProfileImage
                                                              pathType:GBPathImageViewTypeCircle
                                                             pathColor:[UIColor darkGrayColor]
                                                           borderColor:[UIColor darkGrayColor]
                                                             pathWidth:1.0];
    }
}
 */

- (void)setStringUploaderName:(NSString *)stringUploaderName
{
    _stringUploaderName = stringUploaderName;
    self.profileNameLabel.text = _stringUploaderName;
}

- (void)setStringUploadDate:(NSString *)stringUploadDate
{
    _stringUploadDate = stringUploadDate;
    self.uploadDateLabel.text = _stringUploadDate;
}

- (NSString *)commentButtonTitle
{
    return @"4.4k";
}

- (NSString *)likeButtonTitle
{
    return @"9.7k";
}

- (void)addProfileImageViewAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileImageView = [[StringrPathImageView alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)
                                                                  image:[UIImage imageNamed:@"alonsoAvatar.jpg"]
                                                              pathColor:[UIColor darkGrayColor]
                                                              pathWidth:1.0];
    
    
    [self.profileImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushProfilePicture:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageView addGestureRecognizer:singleTap];

    [self.contentFooterView addSubview:self.profileImageView];
}

- (void)pushProfilePicture:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectProfileImage" object:nil];
}


// Adds the given profile name at the preset location and size
- (void)addProfileNameLabelAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.profileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];

    
    //[self.profileNameLabel setText:self.stringUploaderName];
    [self.profileNameLabel setTextColor:[UIColor grayColor]];
    [self.profileNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.profileNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    //[self.profileNameLabel setBackgroundColor:[UIColor purpleColor]];
    [self.contentFooterView addSubview:self.profileNameLabel];
}

// Adds the given upload date at the preset location and size
- (void)addUploadDateLabelAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];

    
    //[self.uploadDateLabel setText:self.stringUploadDate];
    [self.uploadDateLabel setTextColor:[UIColor grayColor]];
    [self.uploadDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.uploadDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:9]];
    [self.contentFooterView addSubview:self.uploadDateLabel];
}





// Adds a compounded NSString, UIImage, and UIButton with the given number of comment's at the preset location and size
- (void)addCommentsButtonAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.commentsTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.commentsTextLabel setText:self.commentButtonTitle];
    [self.commentsTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [self.commentsTextLabel setTextColor:[UIColor grayColor]];
    [self.commentsTextLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentFooterView addSubview:self.commentsTextLabel];
    
    self.commentsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x + 45, location.y, 20, 17)];
    [self.commentsImageView setImage:[UIImage imageNamed:@"comment-bubble.png"]];
    [self.contentFooterView addSubview:self.commentsImageView];
    
    self.commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, 65, 18)];
    [self.commentsButton addTarget:self action:@selector(pushDownCommentsButton) forControlEvents:UIControlEventTouchDown];
    [self.commentsButton addTarget:self action:@selector(pushCommentsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsButton addTarget:self action:@selector(pushCommentsOutside) forControlEvents:UIControlEventTouchUpOutside];
    //[self.commentsButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self.contentFooterView addSubview:self.commentsButton];
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





// Adds a compounded NSString, UIImage, and UIButton with the given number of like's at the preset location and size
- (void)addLikesButtonAtLocation:(CGPoint)location withSize:(CGSize)size
{
    self.likesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, size.width, size.height)];
    [self.likesTextLabel setText:self.likeButtonTitle];
    [self.likesTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
    [self.likesTextLabel setTextColor:[UIColor grayColor]];
    [self.likesTextLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentFooterView addSubview:self.likesTextLabel];
    
    self.likesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(location.x + 45, location.y - 2, 20, 17)];
    [self.likesImageView setImage:[UIImage imageNamed:@"like-bubble.png"]];
    [self.contentFooterView addSubview:self.likesImageView];
    
    self.likesButton = [[UIButton alloc] initWithFrame:CGRectMake(location.x, location.y, 65, 18)];
    [self.likesButton addTarget:self action:@selector(pushDownLikesButton) forControlEvents:UIControlEventTouchDown];
    [self.likesButton addTarget:self action:@selector(pushLikesButton) forControlEvents:UIControlEventTouchUpInside];
    [self.likesButton addTarget:self action:@selector(pushLikesOutside) forControlEvents:UIControlEventTouchUpOutside];

    //[self.likesButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5]];
    [self.contentFooterView addSubview:self.likesButton];
    
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
