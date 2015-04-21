//
//  EAWorkflowListCollectionViewController.h
//  EASE
//
//  Created by Aladin TALEB on 08/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+XLProgressIndicator.h"

#import "EAWorkflowListCollectionViewCell.h"

#import "FRGWaterfallCollectionViewLayout.h"


#import "EAWorkflowMasterViewController.h"
#import "EANetworkingHelper.h"

#import "EASearchResults.h"
#import "EASearchSortTableViewController.h"

@protocol EAWorkflowListDelegate <NSObject>

-(void)workflowListAskToDismiss;

@end

@interface EAWorkflowListCollectionViewController : UICollectionViewController <FRGWaterfallCollectionViewDelegate, EAWorkflowViewerDelegate>
{
    
    NSArray *colors;
    BOOL seekingWorkflows;
}


@property(nonatomic, strong) EASearchResults *searchResults;



@property(nonatomic, readwrite) int totalNumberOfWorkflows;

@property(nonatomic, weak) id <EAWorkflowListDelegate> delegate;


- (IBAction)cancel:(id)sender;

@end
