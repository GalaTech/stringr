//
//  StringrLoadingContentView.m
//  Stringr
//
//  Created by Jonathan Howard on 2/11/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "StringrLoadingContentView.h"
#import "StringrColoredView.h"
#import "UIColor+StringrColors.h"

@interface StringrLoadingContentView ()

@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *noContentLabel;

@end

@implementation StringrLoadingContentView

- (void)awakeFromNib
{
    self.noContentLabel.alpha = 0.0f;
}

- (void)startLoading
{
    [self.activityIndicator startAnimating];
}


- (void)stopLoading
{
    [self.activityIndicator stopAnimating];
}


- (void)enableNoContentViewWithMessage:(NSString *)message
{
    self.noContentLabel.text = message;
    
    CGRect coloredLineRect = self.frame;
    coloredLineRect.size.height = 2.0f;
    StringrColoredView *coloredLineView = [[StringrColoredView alloc] initWithFrame:coloredLineRect colors:[UIColor defaultStringrColors]];
    coloredLineView.alpha = 0.0f;
    
    [self addSubview:coloredLineView];
    
    [UIView animateWithDuration:0.33f animations:^{
        self.loadingLabel.alpha = 0.0f;
        self.activityIndicator.alpha = 0.0f;
        
        self.noContentLabel.alpha = 1.0f;
        coloredLineView.alpha = 1.0f;
    }];
}

@end
