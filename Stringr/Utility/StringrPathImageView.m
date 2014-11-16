//
//  StringrPathImageView.m
//  Stringr
//
//  Created by Jonathan Howard on 1/9/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPathImageView.h"

@interface StringrPathImageView ()

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

@end


@implementation StringrPathImageView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image pathColor:(UIColor *)color pathWidth:(float)width
{
    self = [super init];
//    
    if (self) {
        
        _pathColor = color;
        _pathWidth = width;
        
        self.frame = frame;
        self.image = image;
        
        
       // UIImageView *self = [[UIImageView alloc] initWithFrame:frame];
        //[self setImage:image];
        
        float cornerRadius = frame.size.width / 2;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = width;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //imageView.layer.shouldRasterize = YES;
        self.clipsToBounds = YES;
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        float width = CGRectGetWidth(self.frame);
        float height = CGRectGetHeight(self.frame);
        
        self.loadingIndicator.center = CGPointMake(width / 2, height / 2);
        
        [self addSubview:self.loadingIndicator];
        //self = (StringrPathImageView *)self;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    
    self.loadingIndicator.center = CGPointMake(width / 2, height / 2);
    
    [self addSubview:self.loadingIndicator];
}


#pragma mark - Public

- (void)setImageToCirclePath
{
    float cornerRadius = self.frame.size.width / 2;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    //self.layer.shouldRasterize = YES;
    self.clipsToBounds = YES;
}


- (void)setupImageWithDefaultConfiguration
{
    [self setImageToCirclePath];
    
//    self.pathColor = [UIColor darkGrayColor];
//    self.pathWidth = 1.0f;
}


#pragma mark - Private

- (void)setPathColor:(UIColor *)pathColor
{
    self.layer.borderColor = pathColor.CGColor;
}

- (void)setPathWidth:(float)pathWidth
{
    self.layer.borderWidth = pathWidth;
}

- (void)setPathImage:(UIImage *)image
{
    [self setImage:image];
}


- (void)loadInBackgroundWithIndicator
{
    [self.loadingIndicator startAnimating];
    
    [self loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            self.image = image;
            [self.loadingIndicator stopAnimating];
        }
    }];
}

@end
