//
//  StringrNoContentView.h
//  Stringr
//
//  Created by Jonathan Howard on 5/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringrNoContentView : UIView

/**
 * This will setup a view that contains a centered label with the inputted text.
 * @param frame The frame rectangle for the view, measured in points. The origin of the frame 
 * is relative to the superview in which you plan to add it. This method uses the frame rectangle 
 * to set the center and bounds properties accordingly.
 * @param text The text for the centered UILabel that is contained within this view. The label's height
 * will dynamically change based around the amount of text provided.
 */
- (id)initWithFrame:(CGRect)frame andNoContentText:(NSString *)text; // Designated Initializer

@end
