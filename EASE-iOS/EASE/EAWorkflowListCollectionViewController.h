//
//  EAWorkflowListCollectionViewController.h
//  EASE
//
//  Created by Aladin TALEB on 08/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+XLProgressIndicator.h>

#import "EAWorkflowListCollectionViewCell.h"

#import "FRGWaterfallCollectionViewLayout.h"


#import "EAWorkflowMasterViewController.h"
#import "EANetworkingHelper.h"

@interface EAWorkflowListCollectionViewController : UICollectionViewController <FRGWaterfallCollectionViewDelegate>
{
    
    NSArray *colors;
    BOOL seekingWorkflows;
}


@property(nonatomic, strong) NSArray *workflows;
@property(nonatomic, readwrite) int totalNumberOfWorkflows;

@end
