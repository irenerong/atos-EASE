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

@class EATaskCollectionViewCell;



@interface EATaskCollectionViewCell : UICollectionViewCell
{
    NSMutableArray *buttons;
}

@property(nonatomic, weak) EATask *task;

@property (weak, nonatomic) IBOutlet UIImageView *workflowImageView;

@property (weak, nonatomic) IBOutlet UIView *agentIconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *actionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *labelsBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *agentNameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *dateBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;

@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;

@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *agentNameLabel;

@end
