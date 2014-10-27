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

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) StringrImageAndTextButton *likeButtonView;

@property (weak, nonatomic) IBOutlet UIView *test;

@end

@implementation TestTableViewFooterActionCell

#pragma mark - LifecycleÇ

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.likeButtonView = [[[NSBundle mainBundle] loadNibNamed:@"StringrImageAndTextButton" owner:self options:nil] objectAtIndex:0];
    [self.likeButtonView setImageForSocialButton:[UIImage imageNamed:@"like_button_selected"]];
    [self.likeButtonView.socialButton addTarget:self action:@selector(tappedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.test addSubview:self.likeButtonView];
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
    
    [self.likeButtonView setSocialCount:10];
}


#pragma mark - Actions

- (IBAction)tappedLikeButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(actionCell:tappedLikeButton:withBlock:)]) {
        [self.delegate actionCell:self tappedLikeButton:sender withBlock:^(BOOL success) {
            if (!success) {
                // undo selected state of the like button
                sender.selected = !sender.selected;
            }
        }];
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
