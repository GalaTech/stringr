//
//  StringrPrivacyPolicyTermsOfServiceViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 3/18/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "StringrPrivacyPolicyTermsOfServiceViewController.h"

@interface StringrPrivacyPolicyTermsOfServiceViewController ()

@property (weak, nonatomic) IBOutlet UITextView *legalTextView;

@property (strong, nonatomic) NSString *privacyPolicyText;
@property (strong, nonatomic) NSString *termsOfServiceText;

@end

@implementation StringrPrivacyPolicyTermsOfServiceViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    if (self.isPrivacyPolicy) {
        [self.legalTextView setText:self.privacyPolicyText];
        self.title = @"Privacy Policy";
    } else {
        [self.legalTextView setText:self.termsOfServiceText];
        self.title = @"Terms of Service";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom Accessor's

- (NSString *)privacyPolicyText
{
    NSString *myPath = [[NSBundle mainBundle]pathForResource:@"3-8-14 Updated Privacy Policy for Stringr" ofType:@"txt"];
    _privacyPolicyText = [[NSString alloc] initWithContentsOfFile:myPath encoding:NSUTF8StringEncoding error:nil];
    
    return _privacyPolicyText;
}

- (NSString *)termsOfServiceText
{
    NSString *myPath = [[NSBundle mainBundle]pathForResource:@"3-8-14 Updated Terms of Service for Stringr" ofType:@"txt"];
    _termsOfServiceText = [[NSString alloc] initWithContentsOfFile:myPath encoding:NSUTF8StringEncoding error:nil];
    
    return _termsOfServiceText;
}


@end
