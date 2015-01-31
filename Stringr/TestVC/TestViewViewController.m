//
//  TestViewViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 5/2/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "TestViewViewController.h"
#import "STTweetLabel.h"
#import "UIColor+StringrColors.h"

static NSString * const StringrStringTableViewController = @"StringTable";

@interface TestViewViewController ()

@property (weak, nonatomic) IBOutlet STTweetLabel *testSTTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *responderLabel;

@end

@implementation TestViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


+ (instancetype)viewController
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StringrStringFeedViewController bundle:nil];
//    return (TestViewViewController *)[storyboard instantiateInitialViewController];
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.testSTTweetLabel setText:@"This is a cool label that can tell if there are any @mentions or #hashtags!"];
    
    NSDictionary *handleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHandleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f], NSFontAttributeName, nil];
    NSDictionary *hashtagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor stringrHashtagColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f], NSFontAttributeName, nil];
    
    [self.testSTTweetLabel setAttributes:handleAttributes hotWord:STTweetHandle];
    [self.testSTTweetLabel setAttributes:hashtagAttributes hotWord:STTweetHashtag];
    
    [self.testSTTweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        
        self.responderLabel.text = [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
        //_displayLabel.text =
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
