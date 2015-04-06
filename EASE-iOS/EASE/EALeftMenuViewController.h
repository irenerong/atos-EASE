//
//  EALeftMenuViewController.h
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>

#import "EANetworkingHelper.h"

@interface EALeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *tasksButton;

@property (weak, nonatomic) IBOutlet UILabel *welcomeTextLabel;
- (IBAction)logout:(id)sender;

@end
