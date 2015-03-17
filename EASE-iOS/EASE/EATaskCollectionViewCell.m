//
//  EAPendingTaskCollectionViewCell.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATaskCollectionViewCell.h"

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
    
   
    self.agentNameLabel.textColor = [UIColor whiteColor];
    
    self.actionDescriptionLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1.0];
    
    self.dateBackgroundView.backgroundColor = [UIColor whiteColor];
    
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
    
    
    
    
}

-(void)update
{
    NSArray *colors = @[[UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0], [UIColor colorWithRed:28/255.0 green:253/255.0 blue:171/255.0 alpha:1.0], [UIColor colorWithRed:252/255.0 green:200/255.0 blue:53/255.0 alpha:1.0], [UIColor colorWithRed:253/255.0 green:101/255.0 blue:107/255.0 alpha:1.0], [UIColor colorWithRed:254/255.0 green:100/255.0 blue:192/255.0 alpha:1.0]];
    
    
    UIColor *color = colors[arc4random()%5];
    
    
    self.beginLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.0];
    self.endLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.0];
    
    self.buttonsBackgroundView.backgroundColor = [color colorWithAlphaComponent:0.8];
    
    self.agentNameBackgroundView.backgroundColor = color;
    
    self.agentIconView.backgroundColor = color;
    
    if (self.taskNotification.class == EAPendingTask.class)
    {
        self.statusLabel.text = @"Pending";
        self.beginLabel.textColor = color;

        
    }
    else if (self.taskNotification.class == EAWorkingTask.class)
    {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ (%d%%)", self.taskNotification.status, (int)(100*self.taskNotification.completionPercentage)];
        self.endLabel.textColor = color;


    }

    
    for (UIButton *button in buttons)
        [button removeFromSuperview];
    
    [buttons removeAllObjects];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, self.buttonsBackgroundView.frame.size.height-3)];
    [button addTarget:self action:@selector(didTapCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];

    
    if (_taskNotification.class == EAPendingTask.class)
        [button setTitle:@"Start" forState:UIControlStateNormal];
    
    else if (_taskNotification.class == EAWorkingTask.class)
        [button setTitle:@"Done" forState:UIControlStateNormal];

    
    [self.buttonsBackgroundView addSubview:button];
    [buttons addObject:button];
    
}

-(void)setTaskNotification:(EANotification *)taskNotification {
    
    
    _taskNotification = taskNotification;
    
    
    [self update];
}

-(void)didTapLeftButton:(UIButton*)leftButton
{
    [_delegate taskCellDidTapLeftButton:self];
}

-(void)didTapRightButton:(UIButton*)rightButton
{
    [_delegate taskCellDidTapRightButton:self];
}

-(void)didTapCenterButton:(UIButton*)centerButton
{
    [_delegate taskCellDidTapCenterButton:self];
}



@end
