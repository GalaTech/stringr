//
//  StringrStringFeedModelController.m
//  Stringr
//
//  Created by Jonathan Howard on 2/3/15.
//  Copyright (c) 2015 GalaTech LLC. All rights reserved.
//

#import "STGRStringFeedModelController.h"

#import "StringrNetworkTask+Strings.h"
#import "StringrNetworkTask+Photos.h"
#import "StringrNetworkTask+Activity.h"

#import "StringrString.h"
#import "StringrPhoto.h"

static NSInteger StringQueryResultsLimit = 6;

@interface STGRStringFeedModelController ()

@property (nonatomic, readwrite) NSInteger currentPageNumber;
@property (nonatomic) NSInteger totalStringLimit;

@end

@implementation STGRStringFeedModelController

@synthesize strings = _strings;
@synthesize userForFeed = _userForFeed;


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.currentPageNumber = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [PFQuery clearAllCachedResults];
}


#pragma mark - Accessors

- (NSArray *)strings
{
    if (!_strings) {
        _strings = [NSArray new];
    }
    
    return _strings;
}


- (void)setStrings:(NSArray *)strings
{
    _strings = strings;
    
    [self postUpdateForUpdatedStrings];
    
    if ([self.delegate respondsToSelector:@selector(stringFeedLoadedContent)]) {
        [self.delegate stringFeedLoadedContent];
    }
}


- (void)setDataType:(StringrNetworkStringTaskType)dataType
{
    _dataType = dataType;
    
    [self startStringNetworkTask];
}


- (PFUser *)userForFeed
{
    if (!_userForFeed) {
        _userForFeed = [PFUser currentUser];
    }
    
    return _userForFeed;
}


- (void)setUserForFeed:(PFUser *)userForFeed
{
    if (userForFeed != _userForFeed) {
        _userForFeed = userForFeed;
    }
}


- (void)setCategory:(StringrExploreCategory *)category
{
    _category = category;
    
    [self startStringNetworkTask];
}


- (NSInteger)currentPageNumber
{
    _currentPageNumber = [self pageNumberFromNumber:self.strings.count secondNumber:StringQueryResultsLimit];
    return _currentPageNumber;
}


- (BOOL)hasNextPage
{
    return [self pageNumberFromNumber:self.totalStringLimit secondNumber:StringQueryResultsLimit] > self.currentPageNumber;
}


#pragma mark - Public

- (void)refresh
{
    [self startStringNetworkTask];
}


#pragma mark - Networking

- (void)loadNextPage
{
    if (self.isLoading) return;
    self.isLoading = YES;
    
    StringrNetworkTask *networkTask = [StringrNetworkTask new];
    networkTask.limit = StringQueryResultsLimit;
    networkTask.skip = self.strings.count;
    
    if (self.category) {
        [networkTask stringsForCategory:self.category completion:^(NSArray *strings, NSError *error) {
            self.isLoading = NO;
            self.strings = [self.strings arrayByAddingObjectsFromArray:strings];
        }];
    }
    else {
        [networkTask stringsForDataType:self.dataType user:self.userForFeed completion:^(NSArray *strings, NSError *error) {
            self.isLoading = NO;
            self.strings = [self.strings arrayByAddingObjectsFromArray:strings];
        }];
    }
}


- (void)startStringNetworkTask
{
    if ([self.delegate respondsToSelector:@selector(stringFeedDataWillUpdate)]) {
        [self.delegate stringFeedDataWillUpdate];
    }
    
    if (self.category) {
        [[StringrNetworkTask new] stringCountForCategory:self.category user:self.userForFeed completion:^(NSInteger count, NSError *error) {
            self.totalStringLimit = count;
            
            if (count == 0) {
                if ([self.delegate respondsToSelector:@selector(stringFeedLoadedNoContent)]) {
                    [self.delegate stringFeedLoadedNoContent];
                }
            }
            else {
                [self loadNextPage];
            }
        }];
    }
    else {
        [[StringrNetworkTask new] stringCountForDataType:self.dataType user:self.userForFeed completion:^(NSInteger count, NSError *error) {
            self.totalStringLimit = count;
            
            if (count == 0) {
                if ([self.delegate respondsToSelector:@selector(stringFeedLoadedNoContent)]) {
                    [self.delegate stringFeedLoadedNoContent];
                }
            }
            else {
                [self loadNextPage];
            }
        }];
    }
}


- (void)loadStringPhotoData
{
    if (self.strings.count == 0) return;
    
    for (NSInteger i = (self.currentPageNumber - 1) * StringQueryResultsLimit; i < self.strings.count; i++) {
        StringrString *string = self.strings[i];
        
        if (!string) continue;
        
        __block NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        
        if ([self.delegate respondsToSelector:@selector(stringPhotosWillUpdateAtIndexPath:)]) {
            [self.delegate stringPhotosWillUpdateAtIndexPath:cellIndexPath];
        }
        
        [StringrNetworkTask photosForString:string.parseString completion:^(NSArray *photos, NSError *error) {
            if (!error) {
                string.photos = [photos mutableCopy];
                
                if ([self.delegate respondsToSelector:@selector(stringFeedPhotosDidUpdateAtIndexPath:)]) {
                    [self.delegate stringFeedPhotosDidUpdateAtIndexPath:cellIndexPath];
                }
            }
        }];
    }
}


#pragma mark - Private

- (NSInteger)pageNumberFromNumber:(CGFloat)number secondNumber:(CGFloat)secondNumber
{
    NSInteger pageNumber = ceil(number / secondNumber);
    return pageNumber;
}


- (void)postUpdateForUpdatedStrings
{
    NSInteger previousPageNumber = (self.currentPageNumber - 1 >= 0) ? self.currentPageNumber - 1 : 0;
    NSInteger currentStringIndex = previousPageNumber * StringQueryResultsLimit;
    
    NSMutableArray *indexSets = [NSMutableArray new];
    
    for (NSInteger index = currentStringIndex; index < self.strings.count; index++) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [indexSets addObject:indexSet];
    }
    
    if ([self.delegate respondsToSelector:@selector(stringFeedPhotosDidUpdateAtIndexPath:)]) {
        [self.delegate stringFeedDataDidLoadForIndexSets:[indexSets copy]];
    }
    
    [self loadStringPhotoData];
}

@end
