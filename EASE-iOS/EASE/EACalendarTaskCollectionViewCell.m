//
//  EACalendarTaskCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 30/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarTaskCollectionViewCell.h"

@implementation EACalendarTaskCollectionViewCell

-(void)setTask:(EATask *)task
{
    _task = task;
    
    _workflowTitleBackgroundView.layer.masksToBounds = false;
    _workflowTitleBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _workflowTitleBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    _workflowTitleBackgroundView.layer.shadowOpacity = 0.1;
    _workflowTitleBackgroundView.layer.shadowRadius = 2;
    
    self.workflowImageView.clipsToBounds = true;
    self.workflowTitleBackgroundView.backgroundColor = self.task.workflow.color;
    
    self.workflowTitleLabel.text = self.task.workflow.title;
    self.workflowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    self.workflowTitleLabel.textColor = [UIColor whiteColor];
    
    
    
    self.taskTitleBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.taskTitleLabel.textColor = self.task.workflow.color;
    self.taskTitleLabel.text = self.task.title;
    self.taskTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];

   
      self.workflowImageView.image = [[UIImage imageNamed:@"poulet.jpg"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
}

@end
