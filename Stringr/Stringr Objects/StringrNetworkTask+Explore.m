//
//  StringrNetworkTask+Explore.m
//  Stringr
//
//  Created by Jonathan Howard on 12/17/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrNetworkTask+Explore.h"
#import "StringrExploreCategory.h"
#import "StringrTableSection.h"
#import "UIColor+StringrColors.h"

@implementation StringrNetworkTask (Explore)

+ (void)exploreCategorySections:(void (^)(NSArray *categorySections, NSError *error))completionBlock
{
    PFQuery *exploreCategoriesQuery = [PFQuery queryWithClassName:@"Explore"];
    [exploreCategoriesQuery orderByAscending:@"CategorySection"];
    [exploreCategoriesQuery addAscendingOrder:@"CategoryOrder"];
    [exploreCategoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSMutableArray *categories = [[NSMutableArray alloc] initWithCapacity:objects.count];
        
        for (PFObject *object in objects) {
            StringrExploreCategory *category = [StringrExploreCategory new];
            
            category.name = object[@"CategoryName"];
            
            struct StringrRGBValue rgbColor;
            
            NSArray *colorValues = [(NSString *)object[@"CategoryColor"] componentsSeparatedByString:@"-"];
            
            if (colorValues.count == 3) {
                rgbColor.red = [colorValues[0] floatValue];
                rgbColor.green = [colorValues[1] floatValue];
                rgbColor.blue = [colorValues[2] floatValue];
                
                category.rgbColor = rgbColor;
            }
            
            NSInteger sectionIndex = [object[@"CategorySection"] integerValue];
            StringrTableSection *tableSection;
            
            if (sectionIndex < [categories count]) {
                 tableSection = categories[sectionIndex];
            }
            
            if (!tableSection) {
                tableSection = [StringrTableSection new];
                categories[sectionIndex] = tableSection;
            }
            
            [tableSection.sectionRows addObject:category];
        }

        if (completionBlock) {
            completionBlock(categories, error);
        }
    }];
}

@end
