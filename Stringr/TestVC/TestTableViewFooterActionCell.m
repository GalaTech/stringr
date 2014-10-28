//
//  TestTableViewFooterActionCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterActionCell.h"
#import "StringrImageAndTextButton.h"

@interface TestTableViewFooterActionCell ()

@property (strong, nonatomic, readwrite) PFObject *string;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UIView *likeButtonView;
@property (strong, nonatomic) StringrImageAndTextButton *likeButton;



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
    frame.size.height = FooterActionCellHeight - (inset * 3);
    
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
    self.likeButton = [[[NSBundle mainBundle] loadNibNamed:@"StringrImageAndTextButton" owner:self options:nil] objectAtIndex:0];
    [self.likeButton setImageForSocialButton:[UIImage imageNamed:@"like_button"]];
    [self.likeButton setSelectedImageForSocialButton:[UIImage imageNamed:@"like_button_selected"]];
    [self.likeButton.socialButton addTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton setSocialCount:0];
    [self.likeButtonView addSubview:self.likeButton];
}


- (void)setCommentsAndLikesWithObject:(PFObject *)object
{
    if (object) {
        NSDictionary *objectAttributes = [[StringrCache sharedCache] attributesForObject:object];
        //NSDictionary *objectAttributes = nil;
        if (objectAttributes) {
            [self setLikesButtonState:[[StringrCache sharedCache] isObjectLikedByCurrentUser:object]];
            
            NSInteger likeCount = [[[StringrCache sharedCache] likeCountForObject:object] integerValue];
            [self.likeButton setSocialCount:likeCount];
            
//            int commentCount = [[[StringrCache sharedCache] commentCountForObject:object] intValue];
//            [self.commentsTextLabel setText:[NSString stringWithFormat:@"%d", commentCount]];
        } else {
            // set alpha to 0 so that they can later fade in
            [self.likeButton setSocialLabelAlpha:0.0f];
//            [self.commentsTextLabel setAlpha:0.0f];
            
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
                        [self.likeButton setSocialLabelAlpha:1.0f];
                        [self.likeButton setSocialCount:likers.count];
                        
//                        [self.commentsTextLabel setAlpha:1.0f];
//                        [self.commentsTextLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)commentors.count]];
                    }];
                    
                }];
            }
        }
    }
}


- (void)setLikesButtonState:(BOOL)selected
{
    if (selected) {
        [self.likeButton.socialButton setSelected:YES];
    } else {
        [self.likeButton.socialButton setSelected:NO];
    }
}


- (void)shouldEnableLikeButton:(BOOL)enable
{
    if (enable) {
        [self.likeButton.socialButton addTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton.socialButton removeTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - Actions

- (IBAction)tappedLikeButton:(UIButton *)sender
{
    if (self.string) {
        [self shouldEnableLikeButton:NO];
        
        BOOL liked = !sender.selected;
        [self setLikesButtonState:liked];
        
        NSUInteger likeCount = [self.likeButton socialCount];
        
        if (liked) {
            [self.likeButton setSocialCount:likeCount + 1];
        }
        else {
            [self.likeButton setSocialCount:likeCount - 1];
        }
        
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
