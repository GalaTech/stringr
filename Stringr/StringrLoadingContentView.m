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

@property (strong, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation StringrLoadingContentView

- (void)awakeFromNib
{
    self.noContentLabel.alpha = 0.0f;
    self.refreshButton.alpha = 0.0f;
}

- (void)startLoading
{
    [self.activityIndicator startAnimating];
}


- (void)stopLoading
{
    [self.activityIndicator stopAnimating];
    [UIView animateWithDuration:0.33f animations:^{
        self.refreshButton.alpha = 1.0f;
        self.loadingLabel.alpha = 0.0f;
        self.activityIndicator.alpha = 0.0f;
    }];
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
        self.noContentLabel.alpha = 1.0f;
        coloredLineView.alpha = 1.0f;
    }];
}


- (IBAction)refreshButtonTouched:(UIButton *)sender
{
    self.refreshButton.alpha = 0.0f;
    self.loadingLabel.alpha = 1.0f;
    self.activityIndicator.alpha = 1.0f;
    [self.activityIndicator startAnimating];
    
    if ([self.delegate respondsToSelector:@selector(loadingContentViewDidTapRefresh:)]) {
        [self.delegate loadingContentViewDidTapRefresh:self];
    }
}

@end
