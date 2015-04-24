//
//  EACalendarWorkflowCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 22/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarWorkflowCollectionViewCell.h"
#import "UIImageView+XLProgressIndicator.h"
@implementation EACalendarWorkflowCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }

    return self;
}

- (void)setWorkflow:(EAWorkflow *)workflow {
    _workflow = workflow;

    self.backgroundColor = [UIColor whiteColor];

    self.layer.masksToBounds = false;
    self.layer.shadowOffset  = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius  = 3;
    self.layer.shadowColor   = [UIColor colorWithWhite:180/255. alpha:1].CGColor;

    _labelBackgroundView.layer.masksToBounds = false;
    _labelBackgroundView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _labelBackgroundView.layer.shadowOffset  = CGSizeMake(0, -2);
    _labelBackgroundView.layer.shadowOpacity = 0.2;
    _labelBackgroundView.layer.shadowRadius  = 2;


    self.workflowImageView.clipsToBounds     = true;
    self.labelBackgroundView.backgroundColor = [UIColor whiteColor];
    self.workflowNameLabel.text              = _workflow.title;
    self.workflowNameLabel.font              = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.workflowNameLabel.textColor         = _workflow.color;

    
    self.checkView.layer.cornerRadius = self.checkView.frame.size.width / 2;
    
    self.checkView.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.checkView.layer.shadowOffset  = CGSizeMake(0, 2);
    self.checkView.layer.shadowOpacity = 0.3;
    self.checkView.layer.shadowRadius  = 2;
    self.checkView.backgroundColor     = workflow.color;
    
    self.checkView.alpha = 0;
    
    if (_workflow.isDone)
        self.checkView.alpha = 1;

    [self.workflowImageView setImageWithProgressIndicatorAndURL:self.workflow.metaworkflow.imageURL placeholderImage:nil imageDidAppearBlock:^(UIImageView *imageView) {


     }];


    [self.workflowImageView.progressIndicatorView setStrokeProgressColor:self.workflow.color];
    [self.workflowImageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];

}

@end
