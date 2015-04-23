//
//  EAWorkflowTaskCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowTaskCollectionViewCell.h"

@implementation EAWorkflowTaskCollectionViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
        
        
        
        self.layer.shadowColor = [UIColor colorWithWhite:210/255. alpha:1.].CGColor;
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1;
        
       
        
        self.layer.masksToBounds = false;
        
        
    }
    
    return self;
}

-(void)setTask:(EATask *)task
{
    _task = task;
    
    
    NSMutableAttributedString *taskNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.metatask.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14]}];
    
    [taskNameString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]}]];
    
    self.taskTitleLabel.numberOfLines = 0;
    self.taskTitleLabel.attributedText = taskNameString;
    self.taskTitleLabel.textColor = _task.workflow.color;
    
    NSMutableAttributedString *agentsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.agent.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]}];
    
    [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.agent.type attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14]}]];
    
    self.agentNameLabel.numberOfLines = 0;
    self.agentNameLabel.attributedText = agentsString;
    
    
}

-(void)setColor:(UIColor *)color
{
    if (color == _color)
        return;
    
    _color = color;
    self.titleSeparatorView.backgroundColor = self.color;
    
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted)
        self.backgroundColor = [UIColor colorWithWhite:240/255. alpha:1.];
    else
        self.backgroundColor = [UIColor whiteColor];

}

@end
