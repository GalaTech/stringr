//
//  StringrDetailDescriptionTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailDescriptionTableViewCell.h"
#import "STTweetLabel.h"

@interface StringrDetailDescriptionTableViewCell ()

@property (weak, nonatomic) IBOutlet STTweetLabel *descriptionLabel;
@property (strong, nonatomic) NSDictionary *textAttributes;

@end

@implementation StringrDetailDescriptionTableViewCell

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
    // Initialization code
    [self.descriptionLabel setNumberOfLines:200];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Custom Accessor's

- (NSDictionary *)textAttributes
{
    if (!_textAttributes) {
        NSMutableParagraphStyle *textAlignment = [[NSMutableParagraphStyle alloc] init];
        [textAlignment setAlignment:NSTextAlignmentLeft];
        
        _textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: NSFontAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13],
                           NSParagraphStyleAttributeName, textAlignment,
                           NSForegroundColorAttributeName, [UIColor darkGrayColor], nil];
    }
    
    return _textAttributes;
}




#pragma mark - Public

- (void)setDescriptionForCell:(NSString *)description
{
    if (description) {
        NSAttributedString *attributedDescriptionText = [[NSAttributedString alloc] initWithString:description attributes:self.textAttributes];
    
        [self.descriptionLabel setAttributedText:attributedDescriptionText];
    }
    
    [self.descriptionLabel setText:description];
    [self.descriptionLabel setNumberOfLines:200];
    
    UIColor *descriptionColor = [UIColor darkGrayColor];
    if ([description isEqualToString:@"Enter the description for your String"] || [description isEqualToString:@"Enter the description for your Photo"]) {
        descriptionColor = [UIColor lightGrayColor];
    }
    
    
    NSMutableParagraphStyle *descriptionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [descriptionParagraphStyle setAlignment:NSTextAlignmentLeft];
    [descriptionParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [descriptionParagraphStyle setParagraphSpacingBefore:40.0f];
    
    NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObjectsAndKeys:descriptionColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, descriptionParagraphStyle, NSParagraphStyleAttributeName, nil];
    [self.descriptionLabel setAttributes:descriptionAttributes];
    
    //[self.titleLabel setText:@"This is a cool label that can tell if there are any @mentions or #hashtags!\n"];
    
    
    NSDictionary *handleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[StringrConstants kStringrHandleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *hashtagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[StringrConstants kStringrHashtagColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    NSDictionary *httpAttributes = [NSDictionary dictionaryWithObjectsAndKeys:descriptionColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f], NSFontAttributeName, nil];
    
    
    [self.descriptionLabel setAttributes:handleAttributes hotWord:STTweetHandle];
    [self.descriptionLabel setAttributes:hashtagAttributes hotWord:STTweetHashtag];
    [self.descriptionLabel setAttributes:httpAttributes hotWord:STTweetLink];
    
    [self.descriptionLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
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

- (NSDictionary *)getDescriptionTextAttributes
{
    return self.textAttributes;
}

@end
