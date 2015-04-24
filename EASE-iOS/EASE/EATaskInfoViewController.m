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
        
        self.agentNameBackgroundView.backgroundColor = color;
        
        self.workflowTitleBackgroundView.backgroundColor = [UIColor whiteColor];
        
        self.workflowTitleLabel.text = _task.workflow.title;
        
        
        
        NSMutableAttributedString *taskNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.metatask.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13]}];
        
        [taskNameString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
        
        self.taskNameLabel.numberOfLines = 0;
        self.taskNameLabel.attributedText = taskNameString;

        
        self.agentNameLabel.textColor = [UIColor whiteColor];
        self.workflowTitleLabel.textColor = color;
        self.taskNameLabel.textColor = [UIColor whiteColor];
        
        self.taskNameBackgroundView.backgroundColor = color;
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
        
        
        NSMutableAttributedString *agentsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.agent.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13]}];
        
        [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.agent.type attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
        
        self.agentNameLabel.attributedText = agentsString;



        
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
        
        
    
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, self.buttonsBackgroundView.frame.size.height-3)];
        [button addTarget:self action:@selector(didTapCenterButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];

        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        
        if (_task.status == EATaskStatusPending)
            [button setTitle:@"Start" forState:UIControlStateNormal];
        
        else
            [button setTitle:@"" forState:UIControlStateNormal];
        
        
        [self.buttonsBackgroundView addSubview:button];
        [buttons addObject:button];
        

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(button.superview).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        
        
        NSString *html = [NSString stringWithFormat:@"<html><head><style>div {max-width: 300px;}</style></head> <body><div>%@</div></body> </html>", task.metatask.desc];
        
        [self.descriptionView loadHTMLString:html baseURL:nil];
        self.descriptionView.delegate = self;

        
        [self.imageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL];
        [self.imageView.progressIndicatorView setStrokeProgressColor:color];
        
        [self.imageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];
         

        
        if (_task.status == EATaskStatusWorking)
        {
            self.statusLabel.text = @"Working";

        }
        
        if (_task.status == EATaskStatusPending)
        {
            self.statusLabel.text = @"Pending";
            
            
        }
        if (_task.status == EATaskStatusWorking)
        {
            self.statusLabel.text = [NSString stringWithFormat:@"Working (%d%%)",  (int)(100*self.task.completionPercentage)];
            self.progressBar.progress = self.task.completionPercentage;
            
        }
        
    }
 }

-(void)webViewDidFinishLoad:(UIWebView *)theWebView
{

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
    
    if (!_task)
        return;
    int taskID = ((NSNumber*)notification.userInfo[@"id"]).intValue;
    
    if (taskID == _task.taskID)
        [_task updateWithFeedback:notification.userInfo];
    
    self.task = _task;
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
