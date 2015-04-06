//
//  EACalendarWorkflowCollectionViewCell.h
//  EASE
//
//  Created by Aladin TALEB on 22/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImage+ImageEffects.h>
#import "EAWorkflow.h"

@interface EACalendarWorkflowCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *workflowImageView;

@property(weak, nonatomic) EAWorkflow *workflow;
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *workflowNameLabel;

@end
