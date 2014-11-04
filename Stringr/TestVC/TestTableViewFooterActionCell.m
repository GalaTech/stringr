//
//  TestTableViewFooterActionCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterActionCell.h"
#import "StringrImageAndTextButton.h"
#import "NSString+StringrAdditions.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"

@interface TestTableViewFooterActionCell ()

@property (strong, nonatomic, readwrite) PFObject *string;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation TestTableViewFooterActionCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupAppearance];
}


- (void)setFrame:(CGRect)frame
{
    // Adds inset to the cell size so that it doesn't fill the full screen width
    CGFloat inset = 4.0f;
    frame.origin.x += inset;
    frame.size.width = self.superview.frame.size.width - 2 * inset;
    frame.size.height = FooterActionCellHeight - (inset * 3.5);
    
    [super setFrame:frame];
}


#pragma mark - Public

- (void)configureActionCellWithString:(PFObject *)string
{
    self.string = string;
    [self setCommentsAndLikesWithObject:string];
}


#pragma mark - Private

- (void)setupAppearance
{
//    self.contentView.userInteractionEnabled = NO;
    
    [self.likeButton setImage:[UIImage imageNamed:@"like_button"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"like_button_selected"] forState:UIControlStateSelected];
    [self.likeButton addTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commentButton setImage:[UIImage imageNamed:@"comment_button"] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(tappedCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likesLabel.textColor = [UIColor stringrSecondaryLabelColor];
    self.likesLabel.font = [UIFont stringrPrimaryLabelFontWithSize:12.0f];
    
    self.commentsLabel.textColor = [UIColor stringrSecondaryLabelColor];
    self.likesLabel.font = [UIFont stringrPrimaryLabelFontWithSize:12.0f];
}


- (void)setCommentsAndLikesWithObject:(PFObject *)object
{
    if (object) {
        NSDictionary *objectAttributes = [[StringrCache sharedCache] attributesForObject:object];
        //NSDictionary *objectAttributes = nil;
        if (objectAttributes) {
            [self setLikesButtonState:[[StringrCache sharedCache] isObjectLikedByCurrentUser:object]];
            
            NSInteger likeCount = [[[StringrCache sharedCache] likeCountForObject:object] integerValue];
            NSString *decimalLikeCountString = [NSString formattedFromInteger:likeCount];
            self.likesLabel.text = [NSString stringWithFormat:@"Likes %@", decimalLikeCountString];
            
            NSInteger commentCount = [[[StringrCache sharedCache] commentCountForObject:object] integerValue];
            NSString *decimalCommentCountString = [NSString formattedFromInteger:commentCount];
            self.commentsLabel.text = [NSString stringWithFormat:@"Comments %@", decimalCommentCountString];
        } else {
            // set alpha to 0 so that they can later fade in
            self.likeButton.alpha = 1.0f;
            self.likesLabel.alpha = 0.0f;
            self.commentsLabel.alpha = 0.0f;
            
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
                    
                    [UIView animateWithDuration:0.33 animations:^ {
                        self.likeButton.alpha = 1.0f;
                        self.likesLabel.alpha = 1.0f;
                        NSString *decimalLikeCountString = [NSString formattedFromInteger:likers.count];
                        self.likesLabel.text = [NSString stringWithFormat:@"Likes %@", decimalLikeCountString];
                        
                        self.commentsLabel.alpha = 1.0f;
                        NSString *decimalCommentCountString = [NSString formattedFromInteger:commentors.count];
                        self.commentsLabel.text = [NSString stringWithFormat:@"Comments %@", decimalCommentCountString];
                    }];
                    
                }];
            }
        }
    }
}


- (void)setLikesButtonState:(BOOL)selected
{
    if (selected) {
        [UIView animateWithDuration:0.33 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.likesLabel.textColor = [UIColor stringrLikedGreenColor];
        } completion:nil];
        [self.likeButton setSelected:YES];
    } else {
        [self.likeButton setSelected:NO];
        self.likesLabel.textColor = [UIColor stringrSecondaryLabelColor];
    }
}


- (void)shouldEnableLikeButton:(BOOL)enable
{
    if (enable) {
        [self.likeButton addTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton removeTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - Actions

- (IBAction)tappedLikeButton:(UIButton *)sender
{
    if (self.string) {
        [self shouldEnableLikeButton:NO];
        
        BOOL liked = !sender.selected;
        [self setLikesButtonState:liked];
        
        NSString *likeCountString = [self.likesLabel.text stringByReplacingOccurrencesOfString:@"Likes " withString:@""];
        NSUInteger likeCount = [likeCountString integerValue];
        NSUInteger newLikeCount = likeCount;
        
        if (liked) {
            newLikeCount++;
        }
        else {
            newLikeCount--;
        }
        
        NSString *decimalLikeCountString = [NSString formattedFromInteger:newLikeCount];
        self.likesLabel.text = [NSString stringWithFormat:@"Likes %@", decimalLikeCountString];
        
        if ([self.delegate respondsToSelector:@selector(actionCell:tappedLikeButton:liked:withBlock:)]) {
            [self.delegate actionCell:self tappedLikeButton:sender liked:liked withBlock:^(BOOL success) {
                if (!success) {
                    [self setLikesButtonState:!sender.selected];
//                    [self.likeButtonView setSocialCount:likeCount];
                }
                
                if (liked) {
                    [self setLikesButtonState:success];
                }
                else {
                    [self setLikesButtonState:!success];
                }
                
                [self shouldEnableLikeButton:YES];
            }];
        }
    }
}


- (IBAction)tappedCommentButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionCell:tappedCommentButton:)]) {
        [self.delegate actionCell:self tappedCommentButton:sender];
    }
}


- (IBAction)tappedActionButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionCell:tappedActionButton:)]) {
        [self.delegate actionCell:self tappedActionButton:sender];
    }
}


@end
