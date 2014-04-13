//
//  StringrDetailDescriptionTableViewCell.m
//  Stringr
//
//  Created by Jonathan Howard on 3/14/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrDetailDescriptionTableViewCell.h"

@interface StringrDetailDescriptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSDictionary *textAttributes;

@end

@implementation StringrDetailDescriptionTableViewCell

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self.descriptionLabel setNumberOfLines:200];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Custom Accessor's

- (NSDictionary *)textAttributes
{
    if (!_textAttributes) {
        NSMutableParagraphStyle *textAlignment = [[NSMutableParagraphStyle alloc] init];
        [textAlignment setAlignment:NSTextAlignmentLeft];
        
        _textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: NSFontAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:13],
                           NSParagraphStyleAttributeName, textAlignment,
                           NSForegroundColorAttributeName, [UIColor darkGrayColor], nil];
    }
    
    return _textAttributes;
}




#pragma mark - Public

- (void)setDescriptionForCell:(NSString *)description
{
    NSAttributedString *attributedDescriptionText = [[NSAttributedString alloc] initWithString:description attributes:self.textAttributes];
    
    [self.descriptionLabel setAttributedText:attributedDescriptionText];    
}

- (NSDictionary *)getDescriptionTextAttributes
{
    return self.textAttributes;
}

@end
