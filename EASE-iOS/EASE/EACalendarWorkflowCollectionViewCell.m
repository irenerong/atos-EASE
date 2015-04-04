//
//  EACalendarWorkflowCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 22/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarWorkflowCollectionViewCell.h"

@implementation EACalendarWorkflowCollectionViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {

    }
    
    return self;
}

-(void)setWorkflow:(EAWorkflow *)workflow
{
    _workflow = workflow;
    
    _labelBackgroundView.layer.masksToBounds = false;
    _labelBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _labelBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    _labelBackgroundView.layer.shadowOpacity = 0.2;
    _labelBackgroundView.layer.shadowRadius = 3;
    
    self.workflowImageView.clipsToBounds = true;
    self.labelBackgroundView.backgroundColor = _workflow.color;
    self.workflowNameLabel.text = _workflow.title;
    self.workflowNameLabel.textColor = [UIColor whiteColor];
    self.workflowNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];

    self.workflowImageView.image = [[UIImage imageNamed:@"poulet.jpg"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    
}

@end
