//
//  EAWorkflowMasterViewController.m
//  EASE
//
//  Created by Aladin TALEB on 11/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowMasterViewController.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"



@interface EAWorkflowMasterViewController ()



@end

@implementation EAWorkflowMasterViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.rightBarButtonItems = @[self.doneButton];

    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:true];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];

    self.frontController = [self.storyboard instantiateViewControllerWithIdentifier:@"FrontViewController"];
    self.backController  = [self.storyboard instantiateViewControllerWithIdentifier:@"BackViewController"];

    self.closedTopOffset = 302;

    if (_workflow) {
        [self setWorkflow:_workflow];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWorkflow:(EAWorkflow *)workflow {
    _workflow = workflow;

    if (self.isViewLoaded) {

        if (_workflow.isValidated)
            self.navigationItem.rightBarButtonItems = @[];
        ((EAWorkflowInfosViewController *)self.frontController).workflow = self.workflow;
        ((EAWorkflowViewController *)self.backController).workflow       = self.workflow;

    }

}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 animations:^{
         self.navigationController.navigationBar.tintColor = self.workflow.color;
     }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReadaptWorkflow"]) {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;

        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle        = MZFormSheetTransitionStyleDropDown;
        formSheet.cornerRadius           = 8.0;
        formSheet.shouldCenterVertically = true;
        formSheet.presentedFormSheetSize = CGSizeMake(300, 300);


        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {

        };

        formSheet.shouldDismissOnBackgroundViewTap = YES;

        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {


        };

    }

}

- (IBAction)validateWorkflow:(id)sender {

    [[EANetworkingHelper sharedHelper] validateWorkflow:self.workflow completionBlock:^(NSError *error) {

         if (error) {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
         } else {
             [self.delegate workflowViewValidatedWorkflow];
         }

     }];

}

@end
