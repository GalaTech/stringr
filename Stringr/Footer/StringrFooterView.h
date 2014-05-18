//
//  StringrFooterView.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringrFooterViewDelegate;

@interface StringrFooterView : UIView

@property (strong, nonatomic) UIActivityIndicatorView *loadingProfileImageIndicator;
@property (nonatomic) NSUInteger section;
@property (weak, nonatomic) id<StringrFooterViewDelegate> delegate;

/** 
 * Inits a new footer view with the provided frame and adjusts based around whether or not
 * it is a full width footer view. Full width footer view would be used as a full width table
 * view cell, like in the detail controllers. A footer view that isn't full width would be used
 * for a standard feed of strings, where the footer view is displayed at a reduced width.
 * @param frame The frame used for containing the footer view objects
 * @param isFullWidth Determines whether or not the cell is a full width footer view.
 */
- (UIView *)initWithFrame:(CGRect)frame fullWidthCell:(BOOL)isFullWidthCell withObject:(PFObject *)object; // Designated Initializer

/// Refreshes the value displayed in the footer for both the Likes and Comments.
- (void)refreshLikesAndComments;

@end

/// Provides a call back after a user taps the profile image, like button, and comment button.
@protocol StringrFooterViewDelegate <NSObject>

@optional

/**
 * Tells the delegate that the footer view user profile image has been tapped.
 * @param footerView The footer view object that is notifying the tapping.
 * @param sender The UIButton that was tapped by the user.
 * @param uploader The PFUser user object that uploaded the String or Photo that is being represented by this footer view.
 */
- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader;

/**
 * Tells the delegate that the footer view like button was tapped.
 * @param footerView The footer view object that is notifying the tapping.
 * @param sender The UIButton that was tapped by the user.
 * @param object The String or Photo object that was liked by the user.
 * @param section The section that this footer view lives at within a calling UITableView
 */
- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object inSection:(NSUInteger)section;

/**
 * Tells the delegate that the footer view comment button was tapped.
 * @param footerView The footer view object that is notifying the tapping.
 * @param sender The UIButton that was tapped by the user.
 * @param object The String or Photo object that will be commented on by the user.
 * @param section The section that this footer view lives at within a calling UITableView
 */
- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object inSection:(NSUInteger)section;

@end
