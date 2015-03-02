//
//  StringrStringFeedModelController.h
//  Stringr
//
//  Created by Jonathan Howard on 2/3/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringrNetworkTask+Strings.h"

@protocol STGRStringFeedModelControllerDelegate;

@interface STGRStringFeedModelController : NSObject

@property (strong, nonatomic) NSArray *strings;
@property (strong, nonatomic) NSMutableArray *stringPhotos;
@property (nonatomic) StringrNetworkStringTaskType dataType;
@property (strong, nonatomic) StringrExploreCategory *category;
@property (strong, nonatomic) PFUser *userForFeed;

@property (nonatomic) BOOL isLoading;
@property (nonatomic, readonly) NSInteger currentPageNumber;
@property (nonatomic) BOOL hasNextPage;

@property (weak, nonatomic) id<STGRStringFeedModelControllerDelegate> delegate;

- (void)loadNextPage;

@end


@protocol STGRStringFeedModelControllerDelegate <NSObject>

- (void)stringFeedLoadedNoContent;
- (void)stringFeedLoadedContent;

- (void)stringFeedDataDidUpdate;
- (void)stringFeedDataDidLoadForIndexSets:(NSArray *)indexSets;

- (void)stringFeedPhotosDidUpdateAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)stringFeedDataWillUpdate;
- (void)stringPhotosWillUpdateAtIndexPath:(NSIndexPath *)indexPath;

@end
