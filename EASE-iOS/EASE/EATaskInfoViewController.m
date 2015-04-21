//
//  EAPendingTaskInfoViewController.m
//  EASE
//
//  Created by Aladin TALEB on 03/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATaskInfoViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+XLProgressIndicator.h"
#import "EAWorkflow.h"
#import "NSDate+Complements.h"
@interface EATaskInfoViewController ()

@end

@implementation EATaskInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.clipsToBounds = true;
    buttons = [NSMutableArray array];
    
    self.progressBar.trackTintColor = [UIColor colorWithWhite:230/255. alpha:1.];
    
    
    self.progressBar.type = YLProgressBarTypeFlat;
    self.progressBar.hideStripes = YES;
    self.progressBar.hideGloss = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateDate) userInfo:nil repeats:true];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskUpdate:) name:EATaskUpdate object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTask:(EATask *)task
{
    
    _task = task;
    
    if (self.isViewLoaded) {
        
        
       
        
        UIColor *color = self.task.workflow.color;
        
        self.agentNameBackgroundView.backgroundColor = [color colorWithAlphaComponent:1];
        self.workflowTitleBackgroundView.backgroundColor = color;
        
        self.workflowTitleLabel.text = _task.workflow.title;
        self.taskNameLabel.text = _task.title;
        
        self.agentNameLabel.textColor = [UIColor whiteColor];
        self.workflowTitleLabel.textColor = [UIColor whiteColor];
        self.taskNameLabel.textColor = [UIColor colorWithWhite:180/255. alpha:1.0];
        
        self.agentNameBackgroundView.layer.masksToBounds = false;
        self.agentNameBackgroundView.layer.shadowOffset = CGSizeMake(0, -2);
        self.agentNameBackgroundView.layer.shadowOpacity = 0.2;
        self.agentNameBackgroundView.layer.shadowRadius = 2;
        self.agentNameBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.taskNameBackgroundView.layer.masksToBounds = false;
        self.taskNameBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        self.taskNameBackgroundView.layer.shadowOpacity = 0.1;
        self.taskNameBackgroundView.layer.shadowRadius = 1;
        self.taskNameBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.dateBackgroundView.layer.masksToBounds = false;
        self.dateBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        self.dateBackgroundView.layer.shadowOpacity = 0.1;
        self.dateBackgroundView.layer.shadowRadius = 3;
        self.dateBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.buttonsBackgroundView.backgroundColor = color;
        self.buttonsBackgroundView.layer.masksToBounds = false;
        self.buttonsBackgroundView.layer.shadowOffset = CGSizeMake(0, -2);
        self.buttonsBackgroundView.layer.shadowOpacity = 0.2;
        self.buttonsBackgroundView.layer.shadowRadius = 3;
        self.buttonsBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.beginLabel.textColor = color;
        self.endLabel.textColor = color;
        
        self.progressBar.progressTintColors = @[color, color];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.doesRelativeDateFormatting = YES;
        
        self.beginLabel.text = [[dateFormatter stringFromDate:self.task.dateInterval.startDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
        self.endLabel.text = [[dateFormatter stringFromDate:self.task.dateInterval.endDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
        
        [self updateDate];
        
        for (UIButton *button in buttons)
            [button removeFromSuperview];
        [buttons removeAllObjects];
        
        
        if (_task.status == EATaskStatusPending || _task.status == EATaskStatusWorking)
        {
            self.buttonsBackgroundView.alpha = 1;

        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, self.buttonsBackgroundView.frame.size.height-3)];
        [button addTarget:self action:@selector(didTapCenterButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];

        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        
        if (_task.status == EATaskStatusPending)
            [button setTitle:@"Start" forState:UIControlStateNormal];
        
        if (_task.status == EATaskStatusWorking)
            [button setTitle:@"Done" forState:UIControlStateNormal];
        
        
        [self.buttonsBackgroundView addSubview:button];
        [buttons addObject:button];
        

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(button.superview).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        
        }
        else
        {
            self.buttonsBackgroundView.alpha = 0;
        }
        
        [self.imageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL];
        [self.imageView.progressIndicatorView setStrokeProgressColor:color];
        
        [self.imageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];
         

        
        if (_task.status == EATaskStatusWorking)
        {
           
        }
        
        if (_task.status == EATaskStatusPending)
        {
            self.statusLabel.text = @"Pending";
            
            
        }
        if (_task.status == EATaskStatusWorking)
        {
            self.statusLabel.text = [NSString stringWithFormat:@"%@ (%d%%)", self.task.textStatus, (int)(100*self.task.completionPercentage)];
            self.progressBar.progress = self.task.completionPercentage;
            
        }
        
    }
 }

-(void)updateDate
{
    if (_task)
        self.timeStatusLabel.text = [NSDate lateFromDate:self.task.dateInterval.startDate];
    
}

-(void)didTapCenterButton:(UIButton*)sender
{
    
    if (_task.status == EATaskStatusPending)
    {
        
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = SlideInFromCenter;
            alert.backgroundType = Blur;
            alert.customViewColor = [UIColor colorWithWhite:200/255. alpha:1.0];
            alert.iconTintColor = [UIColor whiteColor];
            
            [alert addButton:@"Everything's ok ! Let's do it !" actionBlock:^{
                [[EANetworkingHelper sharedHelper] startTask:self.task completionBlock:^(NSError *error) {
                   
                    NSLog(@"START !");
                    
                }];
            }];
            
            [alert showWarning:self title:@"Warning" subTitle:@"Pouet" closeButtonTitle:@"Let me check ..." duration:0];
            
            
        
    }
   
    
   
}

-(void)taskUpdate:(NSNotification*)notification
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
