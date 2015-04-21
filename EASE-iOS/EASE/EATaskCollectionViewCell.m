//
//  EAPendingTaskCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATaskCollectionViewCell.h"
#import "UIImageView+XLProgressIndicator.h"
#import "UIImage+ImageEffects.h"
#import "EAWorkflow.h"

@implementation EATaskCollectionViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

-(void)awakeFromNib
{
    [self initialize];

}


-(void)initialize {
    
    buttons = [NSMutableArray array];
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    /*self.layer.masksToBounds = false;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 3;
    self.layer.shadowColor = [UIColor blackColor].CGColor;*/
    
    
    self.layer.masksToBounds = false;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius = 1;
    self.layer.shadowColor = [UIColor colorWithWhite:210/255. alpha:1.0].CGColor;
    
    
    self.workflowImageView.clipsToBounds = true;
    
    self.agentIconView.layer.cornerRadius = self.agentIconView.frame.size.width/2;
    self.agentIconView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.agentIconView.layer.shadowOffset = CGSizeMake(0, 2);
    self.agentIconView.layer.shadowOpacity = 0.3;
    self.agentIconView.layer.shadowRadius = 2;
    
   
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.actionDescriptionLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1.0];
    
    
    self.dateBackgroundView.layer.masksToBounds = false;
    self.dateBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    self.dateBackgroundView.layer.shadowOpacity = 0.1;
    self.dateBackgroundView.layer.shadowRadius = 3;
    self.dateBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    self.labelsBackgroundView.layer.masksToBounds = false;
    self.labelsBackgroundView.layer.shadowOffset = CGSizeMake(-2, 0);
    self.labelsBackgroundView.layer.shadowOpacity = 0.1;
    self.labelsBackgroundView.layer.shadowRadius = 1;
    self.labelsBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.agentNameLabel.text = @"MicroWave";
    self.agentNameBackgroundView.layer.cornerRadius = 2;
    
    
    
    self.agentNameLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    
    /*
    self.startButton.imageView.clipsToBounds = true;
    self.startButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.startButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.startButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
   
    
    self.dismissButton.imageView.clipsToBounds = true;
    self.dismissButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.dismissButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
     */
    
    self.progressBar.trackTintColor = [UIColor colorWithWhite:230/255. alpha:1.];
    
    
    self.progressBar.type = YLProgressBarTypeFlat;
    self.progressBar.hideStripes = YES;
    self.progressBar.hideGloss = YES;
    
       [self.workflowImageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];
    
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateDate) userInfo:nil repeats:true];

}

-(void)update
{
   
    UIColor *color = self.task.workflow.color;
    
    self.progressBar.progressTintColors = @[color, color];
    
    self.beginLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.0];
    self.endLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.0];
    
    self.titleLabel.text = self.task.workflow.title;
    self.titleBackgroundView.backgroundColor = color;
    self.actionDescriptionLabel.text = self.task.taskDescription;
    
    self.agentNameBackgroundView.backgroundColor = color;

    
    self.agentIconView.backgroundColor = color;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    
    self.beginLabel.text = [[dateFormatter stringFromDate:self.task.dateInterval.startDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
    self.endLabel.text = [[dateFormatter stringFromDate:self.task.dateInterval.endDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];

    [self updateDate];
    
    if (self.task.status == EATaskStatusPending)
    {
        self.statusLabel.text = @"Pending";
        self.beginLabel.textColor = color;

        
    }
    if (self.task.status == EATaskStatusWorking)
    {
        self.statusLabel.text = [NSString stringWithFormat:@"Working (%d%%)", (int)(100*self.task.completionPercentage)];
        self.endLabel.textColor = color;
        [self.progressBar setProgress: self.task.completionPercentage animated:NO];

    }

    
    [self.workflowImageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL ];
    [self.workflowImageView.progressIndicatorView setStrokeProgressColor:color];
    
    

}

-(void)updateDate
{
    if (_task)
    {
        
        if (_task.status == EATaskStatusWorking)
        {
            
            self.timeStatusLabel.text = [NSString stringWithFormat:@"%@ left",[NSDate timeLeftMessage:_task.timeLeft]];

        }
        else if (_task.status == EATaskStatusPending)
        {
            self.timeStatusLabel.text = [NSDate lateFromDate:self.task.dateInterval.startDate];

        }

    }

}

-(void)setTask:(EATask *)task {
    
    
    _task = task;
    
    
    [self update];
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    

        
        if (highlighted)
        {
            self.dateBackgroundView.backgroundColor = [UIColor colorWithWhite:240/255. alpha:1.];
            self.labelsBackgroundView.backgroundColor = [UIColor colorWithWhite:240/255. alpha:1.];

        }
        else
        {
            self.dateBackgroundView.backgroundColor = [UIColor whiteColor];
            self.labelsBackgroundView.backgroundColor = [UIColor whiteColor];
        }


    
}

@end
