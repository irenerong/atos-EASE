//
//  EAWorkflowListCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 08/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowListCollectionViewCell.h"

@implementation EAWorkflowListCollectionViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    
    return self;
}

-(void)initialize
{
    self.layer.masksToBounds = false;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 3;
    
    
    self.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
    self.imageView.clipsToBounds = true;
 
  
    
    self.sortInfosView.layer.cornerRadius = self.sortInfosView.frame.size.width/2;
    
    self.sortInfosView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sortInfosView.layer.shadowOffset = CGSizeMake(0, 2);
    self.sortInfosView.layer.shadowOpacity = 0.3;
    self.sortInfosView.layer.shadowRadius = 2;
    
    self.infosView.layer.masksToBounds = false;
    self.infosView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.infosView.layer.shadowOffset = CGSizeMake(0, -2);
    self.infosView.layer.shadowOpacity = 0.1;
    self.infosView.layer.shadowRadius = 2;
}

-(void)setWorkflow:(EAWorkflow *)workflow
{
    if (_workflow == workflow)
        return;
    
    [self initialize];

    
    _workflow = workflow;
    
    self.imageView.image = self.workflow.image;
    self.titleLabel.text = self.workflow.title;
    
    [self.infosCollectionView reloadData];

    
}

-(void)setColor:(UIColor *)color
{
    if (_color == color)
        return;
    
    self.layer.shadowColor = color.CGColor;
    self.titleLabel.textColor = color;

    self.sortInfosView.backgroundColor = [color colorWithAlphaComponent:1];
    self.infosCollectionView.backgroundColor = color;
    
}

@end
