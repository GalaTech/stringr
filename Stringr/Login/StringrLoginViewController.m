//
//  StringrLoginViewController.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrLoginViewController.h"
#import "StringrStringDiscoveryTabBarViewController.h"

#import "StringrProfileViewController.h"



@interface StringrLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property int imageNumber;


@end

@implementation StringrLoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.frostedViewController.panGestureEnabled = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageNumber = 2;
    
    NSTimeInterval time = 10.0;
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(changeBackgroundImage) userInfo:nil repeats:YES];
    
    
    // Disables the menu from being able to be pulled out via gesture
    self.frostedViewController.panGestureEnabled = NO;
}


- (void)changeBackgroundImage
{
    NSString *imageName = @"stockImage*";
    
    // determines which stock image to use next
    switch (self.imageNumber) {
        case 1:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"1"];
            self.imageNumber++;
            break;
        case 2:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"2"];
            self.imageNumber++;
            break;
        case 3:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"3"];
            self.imageNumber++;
            break;
        case 4:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"4"];
            self.imageNumber++;
            break;
        case 5:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"5"];
            self.imageNumber++;
            break;
        case 6:
            imageName = [imageName stringByReplacingOccurrencesOfString:@"*" withString:@"6"];
            self.imageNumber = 1;
            break;
        default:
            break;
    }
    
    // Transitions between the different stock images with a slow cross dissolve
    [UIView transitionWithView:self.backgroundImageView
                      duration:3.0 options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.backgroundImageView setImage:[UIImage imageNamed:imageName]];
                    } completion:nil];
}

- (IBAction)pushToNewView:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    [navigationController pushViewController:stringDiscoveryVC animated:YES];
    
}


- (IBAction)pushToPreLoggedInDiscover:(UIButton *)sender
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    StringrStringDiscoveryTabBarViewController *stringDiscoveryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StringDiscoveryTabBar"];
    
    [navigationController pushViewController:stringDiscoveryVC animated:YES];
}


@end
