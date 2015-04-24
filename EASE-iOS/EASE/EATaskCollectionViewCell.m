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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];

}

- (void)initialize {


    self.workflowImageView.clipsToBounds = true;

    self.backgroundColor = [UIColor whiteColor];


    self.layer.masksToBounds = false;
    self.layer.shadowOffset  = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius  = 1;
    self.layer.shadowColor   = [UIColor colorWithWhite:210/255. alpha:1.0].CGColor;



}

- (void)update {

    UIColor *color = self.task.workflow.color;

    self.progressBar.progressTintColors = @[color, color];
    self.progressBar.hideStripes        = true;
    self.progressBar.trackTintColor     = [UIColor clearColor];
    self.progressBar.type               = YLProgressBarTypeFlat;


    self.separatorView.backgroundColor = color;
    self.workflowTitleLabel.textColor  = color;

    self.workflowTitleLabel.text = self.task.workflow.title;

    self.taskTitleLabel.text = self.task.title;

    [self.workflowImageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL];


    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle                  = NSDateFormatterShortStyle;
    dateFormatter.dateStyle                  = NSDateFormatterNoStyle;
    dateFormatter.doesRelativeDateFormatting = YES;

    self.startLabel.text = [dateFormatter stringFromDate:self.task.dateInterval.startDate];



    if (self.task.status == EATaskStatusPending) {
        self.agentStatusLabel.text = @"Pending";
        [self.progressBar setProgress:0];




        CALayer *layer = [CALayer layer];
        layer.frame                         = CGRectMake(0, 0, 0, self.whiteAgentNameLabel.frame.size.height);
        layer.backgroundColor               = [UIColor whiteColor].CGColor;
        self.whiteAgentNameLabel.layer.mask = layer;
        self.agentNameLabel.layer.mask      = nil;


    }
    if (self.task.status == EATaskStatusWorking) {
        self.agentStatusLabel.text = [NSString stringWithFormat:@"Working\n%d%%", (int)(100*self.task.completionPercentage)];

        [self.progressBar setProgress:self.task.completionPercentage];


        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame           = CGRectMake(-8, 0, self.task.completionPercentage*self.whiteAgentNameLabel.frame.size.width, self.whiteAgentNameLabel.frame.size.height);
        maskLayer.backgroundColor = [UIColor whiteColor].CGColor;

        CALayer *invertedMaskLayer = [CALayer layer];
        invertedMaskLayer.frame           = CGRectMake(self.task.completionPercentage*self.whiteAgentNameLabel.frame.size.width-8, 0, (1-self.task.completionPercentage)*self.whiteAgentNameLabel.frame.size.width, self.whiteAgentNameLabel.frame.size.height);
        invertedMaskLayer.backgroundColor = [UIColor whiteColor].CGColor;

        self.whiteAgentNameLabel.layer.mask = maskLayer;
        self.agentNameLabel.layer.mask      = invertedMaskLayer;


    }

    self.agentNameLabel.text      = self.task.agent.name;
    self.whiteAgentNameLabel.text = self.task.agent.name;
    self.durationLabel.text       = [NSDate timeLeftMessage:self.task.dateInterval.timeInterval];


}

- (void)setTask:(EATask *)task {


    _task = task;


    [self update];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];



    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:240/255. alpha:1.];

    } else {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1.];

    }



}

@end
