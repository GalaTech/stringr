//
//  StringrExploreTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 12/15/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrExploreTableViewCell.h"
#import "StringrExploreCategory.h"
#import "UIColor+StringrColors.h"
#import "UIFont+StringrFonts.h"

CGFloat const StringrExploreCellHeight = 60.0f;

@interface StringrExploreTableViewCell ()

@property (strong, nonatomic) StringrExploreCategory *category;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;

@end

@implementation StringrExploreTableViewCell

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}


- (void)awakeFromNib
{
    [self setupAppearance];
}


- (void)prepareForReuse
{
    self.categoryLabel.text = @"";
    self.categoryImageView = nil;
}


#pragma mark - Public

- (void)configureForCategory:(StringrExploreCategory *)category
{
    self.category = category;
    self.categoryLabel.text = category.name;
    
    UIColor *bgColor = [category categoryColor];
    CALayer* layer = [CALayer layer];
    layer.frame = self.categoryImageView.bounds;
    layer.backgroundColor = bgColor.CGColor;
    [self.categoryImageView.layer addSublayer:layer];
}


#pragma mark - Private

- (void)setupAppearance
{
    self.categoryImageView.layer.cornerRadius = self.categoryImageView.frame.size.height / 2;
    self.categoryImageView.clipsToBounds = YES;
    
    self.categoryLabel.font = [UIFont stringrProfileNameFont];
}

@end
