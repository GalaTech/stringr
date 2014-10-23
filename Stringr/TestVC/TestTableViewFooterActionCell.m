//
//  TestTableViewFooterActionCell.m
//  Stringr
//
//  Created by Jonathan Howard on 10/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestTableViewFooterActionCell.h"

@interface TestTableViewFooterActionCell ()

@property (strong, nonatomic, readwrite) PFObject *string;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation TestTableViewFooterActionCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


- (void)setFrame:(CGRect)frame
{
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
}


#pragma mark - Actions

- (IBAction)tappedLikeButton:(UIButton *)sender
{
    // change selected state of like button.
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
