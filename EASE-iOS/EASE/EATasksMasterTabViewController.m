//
//  EATasksMasterTabViewController.m
//  EASE
//
//  Created by Aladin TALEB on 21/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATasksMasterTabViewController.h"

@interface EATasksMasterTabViewController ()

@end

@implementation EATasksMasterTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge) name:EATaskUpdate object:nil];
    
    [self updateBadge];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateBadge
{
    [[EANetworkingHelper sharedHelper] getNumberOfPendingTasks:^(int nb, NSError *error) {
       
        
        [((UITabBarItem*)self.tabBar.items[0]) setCustomBadgeValue:[NSString stringWithFormat:@"%d", nb] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0]];
        
    }];
    
    [[EANetworkingHelper sharedHelper] getNumberOfWorkingTasks:^(int nb, NSError *error) {
        
[((UITabBarItem*)self.tabBar.items[1]) setCustomBadgeValue:[NSString stringWithFormat:@"%d", nb] withFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0]];
    }];
}

@end
