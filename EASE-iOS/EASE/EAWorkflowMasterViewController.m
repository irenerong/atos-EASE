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

@interface UINavigationItem(MultipleButtonsAddition)
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* rightBarButtonItemsCollection;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* leftBarButtonItemsCollection;
@end

@implementation UINavigationItem(MultipleButtonsAddition)

- (void) setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    self.rightBarButtonItems = [rightBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (void) setLeftBarButtonItemsCollection:(NSArray *)leftBarButtonItemsCollection {
    self.leftBarButtonItems = [leftBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (NSArray*) rightBarButtonItemsCollection {
    return self.rightBarButtonItems;
}

- (NSArray*) leftBarButtonItemsCollection {
    return self.leftBarButtonItems;
}

@end





@interface EAWorkflowMasterViewController ()

@end

@implementation EAWorkflowMasterViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
      
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:true];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    EAWorkflowViewController *frontViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FrontViewController"];
    frontViewController.workflow = self.workflow;
    
    EAWorkflowInfosViewController *backViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BackViewController"];
    backViewController.workflow = self.workflow;
    
    self.closedTopOffset = 302;
    
    self.backController = backViewController;
    
    self.frontController = frontViewController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReadaptWorkflow"])
    {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldCenterVertically = true;
        formSheet.presentedFormSheetSize = CGSizeMake(300, 300);
        
        
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
            
        };
        
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        
        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            
            
        };
        
    }

}


@end
