//
//  ViewController.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EACollectionViewWorkflowLayout.h"
#import "EAWorkflowTaskCollectionViewCell.h"
#import "EAWorkflowDateScrollView.h"

#import "EAWorkflowInfosViewController.h"

#import "EAWorkflow.h"

@interface EAWorkflowViewController : UICollectionViewController <UICollectionViewDataSource, EACollectionViewWorkflowLayoutDelegate>


@property (strong, nonatomic) EAWorkflowDateScrollView *dateScrollView;

@property(nonatomic, weak) EAWorkflow *workflow;

@end

