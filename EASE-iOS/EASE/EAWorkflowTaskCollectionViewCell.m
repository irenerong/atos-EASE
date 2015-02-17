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
        
        
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 2;
        
       
        
        self.layer.masksToBounds = false;
        
        
    }
    
    return self;
}

-(void)setTask:(EATask *)task
{
    _task = task;
    
    self.taskTitleLabel.text = task.title;
    self.taskDescriptionLabel.text = task.taskDescription;
    
    
}

-(void)setColor:(UIColor *)color
{
    if (color == _color)
        return;
    
    _color = color;
    self.titleSeparatorView.backgroundColor = self.color;
    
}

@end
