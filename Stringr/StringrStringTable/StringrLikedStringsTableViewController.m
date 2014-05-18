//
//  StringrLikedStringsTableViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/29/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrLikedStringsTableViewController.h"

@interface StringrLikedStringsTableViewController ()

@end

@implementation StringrLikedStringsTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Liked Strings";
}




#pragma mark - PFQueryTableViewController Delegate

- (PFQuery *)queryForTable
{
    PFQuery *likedStringsQuery = [PFQuery queryWithClassName:kStringrActivityClassKey];
    [likedStringsQuery whereKey:kStringrActivityTypeKey equalTo:kStringrActivityTypeLike];
    [likedStringsQuery whereKey:kStringrActivityFromUserKey equalTo:[PFUser currentUser]];
    [likedStringsQuery whereKeyExists:kStringrActivityStringKey];
    [likedStringsQuery includeKey:kStringrActivityStringKey];
    [likedStringsQuery orderByDescending:@"createdAt"];
    [likedStringsQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    
    return likedStringsQuery;
}


@end
