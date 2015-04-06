//
//  EARootViewController.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EARootViewController.h"
#import <UIImage+ImageEffects.h>

@interface EARootViewController ()

@end

@implementation EARootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 2);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 3;
    self.contentViewShadowEnabled = YES;
    self.backgroundImage = [[UIImage imageNamed:@"LoginBG"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"calendarViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuController"];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
