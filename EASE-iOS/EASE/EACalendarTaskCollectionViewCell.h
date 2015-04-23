//
//  EACalendarTaskCollectionViewCell.h
//  EASE
//
//  Created by Aladin TALEB on 30/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "EAWorkflow.h"
#import "EATask.h"

@interface EACalendarTaskCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) EATask *task;
@property (weak, nonatomic) IBOutlet UIImageView *workflowImageView;

@property (weak, nonatomic) IBOutlet UILabel *workflowTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *workflowTitleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *taskTitleBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
