//
//  StringrFooterView.h
//  Stringr
//
//  Created by Jonathan Howard on 1/20/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringrPathImageView.h"

@protocol StringrFooterViewDelegate;

@interface StringrFooterView : UIView

@property (strong, nonatomic) UIActivityIndicatorView *loadingProfileImageIndicator;
@property (strong, nonatomic) id<StringrFooterViewDelegate> delegate;


/** 
 * Inits a new footer view with the provided frame and adjusts based around whether or not
 * it is a full width footer view. Full width footer view would be used as a full width table
 * view cell, like in the detail controllers. A footer view that isn't full width would be used
 * for a standard feed of strings, where the footer view is displayed at a reduced width.
 * @param frame The frame used for containing the footer view objects
 * @param isFullWidth Determines whether or not the cell is a full width footer view.
 */
- (UIView *)initWithFrame:(CGRect)frame fullWidthCell:(BOOL)isFullWidthCell withObject:(PFObject *)object;

/**
 * Set's the uploader profile image and display name to that of the object's uploader.
 * @param object The object that contains information about the photo/string.
 */
- (void)setupFooterViewWithObject:(PFObject *)object;

- (void)refreshLikesAndComments;

/** 
 * Starts animation and displays or stops animation and hides the loading indicator.
 * @param enabled Whether or not the loading indicator is animating and is displayed.
 */
- (void)loadingProfileImageIndicatorEnabled:(BOOL)enabled;

@end

/**
 * Allows simple response from the footer view to user interaction with the objects it contains.
 * Provides a call back after a user taps the profile image, like button, and comment button.
 */
@protocol StringrFooterViewDelegate <NSObject>

@optional

- (void)stringrFooterView:(StringrFooterView *)footerView didTapUploaderProfileImageButton:(UIButton *)sender uploader:(PFUser *)uploader;

- (void)stringrFooterView:(StringrFooterView *)footerView didTapLikeButton:(UIButton *)sender objectToLike:(PFObject *)object;

- (void)stringrFooterView:(StringrFooterView *)footerView didTapCommentButton:(UIButton *)sender objectToCommentOn:(PFObject *)object;

@end
