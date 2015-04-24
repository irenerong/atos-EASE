//
//  EACalendarTaskCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 30/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarTaskCollectionViewCell.h"
#import "UIImageView+XLProgressIndicator.h"

@implementation EACalendarTaskCollectionViewCell

-(void)setTask:(EATask *)task
{
    _task = task;
    
   /* _workflowTitleBackgroundView.layer.masksToBounds = false;
    _workflowTitleBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _workflowTitleBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    _workflowTitleBackgroundView.layer.shadowOpacity = 0.1;
    _workflowTitleBackgroundView.layer.shadowRadius = 1;
    */
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.masksToBounds = false;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 3;
    self.layer.shadowColor = [UIColor colorWithWhite:180/255. alpha:1].CGColor;
    
   
    
    self.workflowImageView.clipsToBounds = true;
    self.workflowTitleBackgroundView.backgroundColor = [UIColor whiteColor];
    
    self.workflowTitleLabel.text = self.task.workflow.title;
    self.workflowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.workflowTitleLabel.textColor = self.task.workflow.color;
    
    
    self.separatorView.backgroundColor = _task.workflow.color;
    self.taskTitleBackgroundView.backgroundColor = [UIColor whiteColor];
    self.taskTitleLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.];

    
    NSMutableAttributedString *taskNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.metatask.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]}];
    
    [taskNameString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14]}]];
    
    self.taskTitleLabel.numberOfLines = 0;
    self.taskTitleLabel.attributedText = taskNameString;

    
    [self.workflowImageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL];
    [self.workflowImageView.progressIndicatorView setStrokeProgressColor:self.task.workflow.color];
    [self.workflowImageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];}

@end
