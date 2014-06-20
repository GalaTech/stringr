//
//  StringrInviteUserTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 4/21/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrInviteUserTableViewCell.h"
#import "UIImage+Resize.h"

@interface StringrInviteUserTableViewCell () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (strong, nonatomic) UIImage *userProfileImage;
@property (strong, nonatomic) NSMutableData *profileImageData;



@end

@implementation StringrInviteUserTableViewCell

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
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
        //self.userProfileImageView = nil;
   // self.userProfileImage = nil;
    [self.userProfileImageView setImage:nil];
    
}



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)setUserToInviteDisplayName:(NSString *)name
{
    [self.userDisplayName setText:name];
}

- (void)setUserToInviteProfileImage:(UIImage *)image
{
    [self.userProfileImageView setImage:image];
}

- (void)setUserToInviteProfileImageURL:(NSURL *)url
{
    [self downloadProfileImage:url];
}



//*********************************************************************************/
#pragma mark - Private
//*********************************************************************************/

- (void)downloadProfileImage:(NSURL *)facebookProfilePictureURL
{
    // Download the user's social network profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    NSURL *pictureURL = facebookProfilePictureURL;
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:2.0f];
    // Run network request asynchronously
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!urlConnection) {
        NSLog(@"Failed to download picture");
    }
}


//*********************************************************************************/
#pragma mark - NSURLConnection Delegate
//*********************************************************************************/

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}



//*********************************************************************************/
#pragma mark - NSURLConnectionDataDelegate
//*********************************************************************************/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *facebookProfileImage = [UIImage imageWithData:self.profileImageData];
    self.userProfileImage = [facebookProfileImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
    [self.userProfileImageView setImage:self.userProfileImage];
}

@end
