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

@protocol EAWorkflowViewerDelegate <NSObject>

- (void)workflowViewValidatedWorkflow;

@end

@interface EAWorkflowMasterViewController : MBPullDownController


@property (weak, nonatomic) EAWorkflow                 *workflow;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)validateWorkflow:(id)sender;

@property(weak, nonatomic) id <EAWorkflowViewerDelegate> delegate;

@end
