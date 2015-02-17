//
//  EAWorkflowTaskCollectionViewCell.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EATask.h"

@interface EAWorkflowTaskCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) EATask *task;

@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *agentTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *agentNameLabel;

@property(nonatomic, weak) UIColor *color;
@property (weak, nonatomic) IBOutlet UIView *titleSeparatorView;

@end
