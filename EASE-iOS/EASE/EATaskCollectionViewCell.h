//
//  EAPendingTaskCollectionViewCell.h
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "EAPendingTask.h"
#import "EAWorkingTask.h"
#import "NSDate+Complements.h"
#import "UIImageView+XLProgressIndicator.h"
#import "NSDate+Complements.h"
@class EATaskCollectionViewCell;



@interface EATaskCollectionViewCell : UICollectionViewCell


@property (nonatomic, weak) EATask *task;


@property (weak, nonatomic) IBOutlet UIImageView *workflowImageView;

@property (weak, nonatomic) IBOutlet UILabel *workflowTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteAgentNameLabel;

@property (weak, nonatomic) IBOutlet UILabel       *agentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel       *agentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel       *startLabel;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;

@property (weak, nonatomic) IBOutlet UIView  *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end
