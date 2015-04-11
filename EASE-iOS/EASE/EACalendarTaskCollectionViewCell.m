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
    self.layer.shadowColor = [UIColor colorWithWhite:100/255. alpha:1.0].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    
    self.workflowImageView.clipsToBounds = true;
    self.workflowTitleBackgroundView.backgroundColor = self.task.workflow.color;
    
    self.workflowTitleLabel.text = self.task.workflow.title;
    self.workflowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    self.workflowTitleLabel.textColor = [UIColor whiteColor];
    
    
    
    self.taskTitleBackgroundView.backgroundColor = self.task.workflow.color;
    self.taskTitleLabel.textColor = [UIColor whiteColor];
    self.taskTitleLabel.text = self.task.title;
    self.taskTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];

   
    
    [self.workflowImageView setImageWithProgressIndicatorAndURL:self.task.workflow.imageURL placeholderImage:nil imageDidAppearBlock:^(UIImageView *imageView) {
        
        imageView.image = [imageView.image applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
        
    }];
    [self.workflowImageView.progressIndicatorView setStrokeProgressColor:self.task.workflow.color];
    [self.workflowImageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];}

@end
