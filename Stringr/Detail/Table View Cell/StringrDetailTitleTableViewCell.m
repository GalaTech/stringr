//
//  StringrDetailTitleTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailTitleTableViewCell.h"
#import "STTweetLabel.h"
#import "UIColor+StringrColors.h"

@interface StringrDetailTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet STTweetLabel *titleLabel;

@end

@implementation StringrDetailTitleTableViewCell

//*********************************************************************************/
#pragma mark - Lifecycle
//*********************************************************************************/

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



//*********************************************************************************/
#pragma mark - Public
//*********************************************************************************/

- (void)setTitleForCell:(NSString *)title
{
    [self.titleLabel setNumberOfLines:200];
    
    UIColor *titleColor  = [UIColor darkGrayColor];
    if ([title isEqualToString:@"Enter the title for your String"] || [title isEqualToString:@"Enter the title for your Photo"]) {
        titleColor = [UIColor lightGrayColor];
    }
    
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [titleParagraphStyle setAlignment:NSTextAlignmentLeft];
    [titleParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [titleParagraphStyle setParagraphSpacingBefore:40.0f];
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:titleColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, titleParagraphStyle, NSParagraphStyleAttributeName, nil];
    
    NSDictionary *handleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHandleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *hashtagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHashtagColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *httpAttributes = [NSDictionary dictionaryWithObjectsAndKeys:titleColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleLabel setText:title];
        
        [self.titleLabel setAttributes:titleAttributes];
        
        [self.titleLabel setAttributes:handleAttributes hotWord:STTweetHandle];
        [self.titleLabel setAttributes:hashtagAttributes hotWord:STTweetHashtag];
        [self.titleLabel setAttributes:httpAttributes hotWord:STTweetLink];
    });
    
    
    [self.titleLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        if (hotWord == STTweetHandle) {
            NSString *username = [[string stringByReplacingOccurrencesOfString:@"@" withString:@""] lowercaseString];
            
            if ([self.delegate respondsToSelector:@selector(tableViewCell:tappedUserHandleWithName:)]) {
                [self.delegate tableViewCell:self tappedUserHandleWithName:username];
            }
        } else if (hotWord == STTweetHashtag) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:tappedHashtagWithText:)]) {
                [self.delegate tableViewCell:self tappedHashtagWithText:string];
            }
        }
    }];
}

@end
