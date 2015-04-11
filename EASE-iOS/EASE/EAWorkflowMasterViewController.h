//
//  EAWorkflowMasterViewController.h
//  EASE
//
//  Created by Aladin TALEB on 11/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "MBPullDownController.h"
#import "EANetworkingHelper.h"
#import "EAWorkflowViewController.h"
#import "EAWorkflowInfosViewController.h"


@interface EAWorkflowMasterViewController : MBPullDownController


@property(nonatomic, weak) EAWorkflow *workflow;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)validateWorkflow:(id)sender;


@end
